import {Router} from "express";
import {streamEventById, streamEvents} from "../../controllers/eventController";

const router = Router();
router.get("/events", streamEvents); // Stream all events
router.get("/events/:id", streamEventById); // Stream a specific event by ID

export default router;
