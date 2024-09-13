import "./firebaseAdmin";
import express from "express";
import cors from "cors";
import eventRoutes from "./routes/events";

const app = express();

app.use(cors({origin: true}));
app.use(express.json());

app.use("/events", eventRoutes);

export default app;
