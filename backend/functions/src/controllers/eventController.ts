import {admin} from "../firebaseAdmin";
import {Request, Response} from "express";

const db = admin.firestore();
const eventsCollection = db.collection("events");

export const createEvent = async (req: Request, res: Response) => {
  try {
    const eventData = req.body;
    eventData.updatedAt = admin.firestore.FieldValue.serverTimestamp();
    const eventRef = await eventsCollection.add(eventData);
    res.status(201).json({id: eventRef.id});
  } catch (error) {
    if (error instanceof Error) {
      res.status(500).json({error: error.message});
    } else {
      res.status(500).json({error: "An unknown error occurred"});
    }
  }
};

export const getEvents = async (req: Request, res: Response) => {
  try {
    const snapshot = await eventsCollection.get();
    const events = snapshot.docs.map((doc) => ({id: doc.id, ...doc.data()}));
    res.status(200).json(events);
  } catch (error) {
    if (error instanceof Error) {
      res.status(500).json({error: error.message});
    } else {
      res.status(500).json({error: "An unknown error occurred"});
    }
  }
};

export const getEventById = async (req: Request, res: Response) => {
  try {
    const eventRef = eventsCollection.doc(req.params.id);
    const eventDoc = await eventRef.get();
    if (!eventDoc.exists) {
      return res.status(404).json({error: "Event not found"});
    }
    return res.status(200).json({id: eventDoc.id, ...eventDoc.data()});
  } catch (error) {
    if (error instanceof Error) {
      return res.status(500).json({error: error.message});
    } else {
      return res.status(500).json({error: "An unknown error occurred"});
    }
  }
};

export const updateEvent = async (req: Request, res: Response) => {
  try {
    const eventRef = eventsCollection.doc(req.params.id);
    await eventRef.update({
      ...req.body,
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
    res.status(200).json({id: req.params.id});
  } catch (error) {
    if (error instanceof Error) {
      res.status(500).json({error: error.message});
    } else {
      res.status(500).json({error: "An unknown error occurred"});
    }
  }
};

export const deleteEvent = async (req: Request, res: Response) => {
  try {
    const eventRef = eventsCollection.doc(req.params.id);
    await eventRef.delete();
    res.status(200).json({message: "Event deleted"});
  } catch (error) {
    if (error instanceof Error) {
      res.status(500).json({error: error.message});
    } else {
      res.status(500).json({error: "An unknown error occurred"});
    }
  }
};

export const streamEventById = async (req: Request, res: Response) => {
  try {
    const eventRef = eventsCollection.doc(req.params.id);

    // Set headers for SSE
    res.setHeader("Content-Type", "text/event-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.setHeader("Connection", "keep-alive");
    res.flushHeaders(); // Flush headers immediately to establish SSE connection

    // Listen for changes to the document
    const unsubscribe = eventRef.onSnapshot((docSnapshot) => {
      if (docSnapshot.exists) {
        const eventData = docSnapshot.data();
        res.write(`data: ${JSON.stringify(eventData)}\n\n`);
      } else {
        res.write("data: {}\n\n"); // Send empty object if document doesn't exist
      }
    }, (error) => {
      res.write(`event: error\ndata: ${JSON.stringify({error: error.message})}\n\n`);
    });

    // Close the stream if the client disconnects
    req.on("close", () => {
      unsubscribe(); // Stop listening to Firestore updates
      res.end(); // End the SSE response
    });
  } catch (error) {
    if (error instanceof Error) {
      res.status(500).json({error: error.message});
    } else {
      res.status(500).json({error: "An unknown error occurred"});
    }
  }
};

export const streamEvents = async (req: Request, res: Response) => {
  try {
    const {eventType} = req.query as { eventType?: string }; // Get the eventType from query parameters

    // Set headers for SSE
    res.setHeader("Content-Type", "text/event-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.setHeader("Connection", "keep-alive");
    res.flushHeaders(); // Flush headers immediately to establish SSE connection

    // Create a query based on the eventType if provided
    let query = eventsCollection as admin.firestore.Query<admin.firestore.DocumentData>;
    if (eventType) {
      query = eventsCollection.where("eventType", "==", eventType) as admin.firestore.Query<admin.firestore.DocumentData>;
    }

    const unsubscribe = query.onSnapshot((querySnapshot) => {
      const events = querySnapshot.docs.map((doc) => doc.data());
      res.write(`data: ${JSON.stringify(events)}\n\n`);
    }, (error) => {
      res.write(`event: error\ndata: ${JSON.stringify({error: error.message})}\n\n`);
    });

    // Close the stream if the client disconnects
    req.on("close", () => {
      unsubscribe(); // Stop listening to Firestore updates
      res.end(); // End the SSE response
    });
  } catch (error) {
    res.status(500).json({error: error instanceof Error ? error.message : "An unknown error occurred"});
  }
};
