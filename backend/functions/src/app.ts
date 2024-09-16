import "./firebaseAdmin";
import express from "express";
import cors from "cors";
import eventRoutes from "./routes/crud/events_crud";
import eventStreamsRoutes from "./routes/streams/events_streams";

const app = express();

app.use(cors({origin: true}));
app.use(express.json());

app.use("/events", eventRoutes);
app.use("/streams", eventStreamsRoutes);

export default app;
