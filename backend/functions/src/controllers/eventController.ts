import {admin} from "../firebaseAdmin";
import {Request, Response} from "express";
import * as functions from "firebase-functions";

const db = admin.firestore();
const eventsCollection = db.collection("events");

export const createEvent = async (req: Request, res: Response): Promise<void> => {
  console.log("createEvent endpoint accessed");
  try {
    const eventData = req.body;

    // Ensure the ID is provided in the request body
    if (!eventData.id) {
      res.status(400).json({error: "Event ID is required"});
      return;
    }

    // Set the ID in the eventData
    const eventId = eventData.id;
    eventData.updatedAt = admin.firestore.FieldValue.serverTimestamp();

    // Create a document reference using the provided ID
    const eventRef = eventsCollection.doc(eventId);

    // Set the event data in the document with the provided ID
    await eventRef.set(eventData);

    // Respond with the document ID
    res.status(201).json({id: eventId});
  } catch (error) {
    if (error instanceof Error) {
      res.status(500).json({error: error.message});
    } else {
      res.status(500).json({error: "An unknown error occurred"});
    }
  }
};

export const getEvents = async (req: Request, res: Response): Promise<void> => {
  console.log("getEvents endpoint accessed");
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

export const getEventById = async (req: Request, res: Response): Promise<void> => {
  console.log("getEventById endpoint accessed");
  try {
    const eventRef = eventsCollection.doc(req.params.id);
    const eventDoc = await eventRef.get();
    if (!eventDoc.exists) {
      res.status(404).json({error: "Event not found"});
    }
    res.status(200).json({id: eventDoc.id, ...eventDoc.data()});
  } catch (error) {
    if (error instanceof Error) {
      res.status(500).json({error: error.message});
    } else {
      res.status(500).json({error: "An unknown error occurred"});
    }
  }
};

export const updateEvent = async (req: Request, res: Response): Promise<void> => {
  console.log("updateEvent endpoint accessed");
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

export const deleteEvent = async (req: Request, res: Response): Promise<void> => {
  console.log("deleteEvent endpoint accessed");
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

export const streamEventById = functions.https.onRequest(async (req: Request, res: Response) => {
  console.log("streamEventById endpoint accessed");

  try {
    const eventId = req.params.id;
    console.log("Event ID:", eventId);

    const eventRef = eventsCollection.doc(eventId);

    // Set headers for SSE
    res.setHeader("Content-Type", "text/event-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.setHeader("Connection", "keep-alive");
    res.setHeader("Access-Control-Allow-Origin", "*"); // CORS for Flutter

    // Listen for changes to the specific event document
    const unsubscribe = eventRef.onSnapshot((docSnapshot) => {
      if (docSnapshot.exists) {
        const eventData = docSnapshot.data();
        // Stream event data to the client
        res.write(`data: ${JSON.stringify(eventData)}\n\n`);
      } else {
        // If the document does not exist, send an empty object
        res.write("data: {}\n\n");
      }
    }, (error) => {
      // Handle Firestore errors
      console.error("Firestore error:", error);
      res.write(`event: error\ndata: ${JSON.stringify({error: error.message})}\n\n`);
    });

    // Handle client disconnection
    req.on("close", () => {
      console.log("Client disconnected, closing Firestore listener.");
      unsubscribe(); // Stop listening to Firestore updates
      res.end(); // End the SSE response
    });
  } catch (error) {
    console.error("Error in streamEventById:", error);
    res.status(500).json({error: error instanceof Error ? error.message : "An unknown error occurred"});
  }
});

export const streamEvents = functions.https.onRequest(async (req: Request, res: Response) => {
  console.log("streamEvents endpoint accessed");

  try {
    const {eventType} = req.query as { eventType?: string };
    console.log("EventType:", eventType);

    // Set headers for SSE
    res.setHeader("Content-Type", "text/event-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.setHeader("Connection", "keep-alive");
    res.setHeader("Access-Control-Allow-Origin", "*"); // CORS for Flutter

    // Create a Firestore query based on the eventType if provided
    let query = eventsCollection as admin.firestore.Query<admin.firestore.DocumentData>;
    if (eventType) {
      query = query.where("eventType", "==", eventType);
    }

    // Start listening for Firestore document changes
    const unsubscribe = query.onSnapshot((querySnapshot) => {
      const events = querySnapshot.docs.map((doc) => ({id: doc.id, ...doc.data()}));

      // Send events or empty array if no events
      res.write(`data: ${JSON.stringify(events.length > 0 ? events : [])}\n\n`);
    }, (error) => {
      // Handle Firestore errors
      console.error("Firestore error:", error);
      res.write(`event: error\ndata: ${JSON.stringify({error: error.message})}\n\n`);
    });

    // Handle client disconnection
    req.on("close", () => {
      console.log("Client disconnected, closing Firestore listener.");
      unsubscribe(); // Stop listening to Firestore updates
      res.end(); // End the SSE response
    });
  } catch (error) {
    console.error("Error in streamEvents:", error);
    res.status(500).json({error: error instanceof Error ? error.message : "An unknown error occurred"});
  }
});
