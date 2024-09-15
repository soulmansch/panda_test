import {Router} from "express";
import {createEvent, getEvents, getEventById, updateEvent, deleteEvent, streamEventById,
  streamEvents} from "../controllers/eventController";

const router = Router();

router.post("/", createEvent);
router.get("/", getEvents);
router.get("/:id", getEventById);
router.put("/:id", updateEvent);
router.delete("/:id", deleteEvent);
router.get("/stream", streamEvents); // Stream all events
router.get("/stream/:id", streamEventById); // Stream a specific event by ID

export default router;
