const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");
require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Initialize Firebase Admin
try {
  const serviceAccount = require("./serviceAccountKey.json");

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });

  console.log("Firebase Admin initialized successfully");
} catch (error) {
  console.error("Error initializing Firebase Admin:", error.message);
  console.error(
    "Please make sure serviceAccountKey.json is in the backend directory"
  );
  process.exit(1);
}

// Routes

// POST /api/topic/notify
app.post("/api/topic/notify", async (req, res) => {
  try {
    const { title, body } = req.body;

    if (!title || !body) {
      return res.status(400).json({
        success: false,
        error: "Title and body are required",
      });
    }

    const message = {
      notification: {
        title: title,
        body: body,
      },
      topic: "everyone",
    };

    const response = await admin.messaging().send(message);

    res.json({
      success: true,
      messageId: response,
      message: "Notification sent successfully",
    });
  } catch (error) {
    console.error("Error sending topic notification:", error);
    res.status(500).json({
      success: false,
      error: error.message || "Failed to send notification",
    });
  }
});

// POST /api/token/notify
app.post("/api/token/notify", async (req, res) => {
  try {
    const { token, title, body } = req.body;

    if (!token || !title || !body) {
      return res.status(400).json({
        success: false,
        error: "Token, title, and body are required",
      });
    }

    const message = {
      notification: {
        title: title,
        body: body,
      },
      token: token,
    };

    const response = await admin.messaging().send(message);

    res.json({
      success: true,
      messageId: response,
      message: "Notification sent successfully",
    });
  } catch (error) {
    console.error("Error sending token notification:", error);

    let statusCode = 500;
    let errorMessage = error.message || "Failed to send notification";

    if (
      error.code === "messaging/invalid-registration-token" ||
      error.code === "messaging/registration-token-not-registered"
    ) {
      statusCode = 400;
      errorMessage = "Invalid or unregistered token";
    }

    res.status(statusCode).json({
      success: false,
      error: errorMessage,
    });
  }
});

// Health check endpoint
app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    timestamp: new Date().toISOString(),
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
