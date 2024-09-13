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
