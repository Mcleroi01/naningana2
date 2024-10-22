require("dotenv").config();
const functions = require("firebase-functions");
const nodemailer = require("nodemailer");
const validator = require("validator");
const cors = require("cors");

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.GMAIL_EMAIL || functions.config().gmail.email,
    pass: process.env.GMAIL_PASSWORD || functions.config().gmail.password,
  },
});

// Options CORS
const corsOptions = {
  origin: "https://game-project-55bad.web.app",
};

exports.sendEmail = functions.https.onRequest((req, res) => {
  // Appliquer CORS
  cors(corsOptions)(req, res, async () => {
    if (req.method !== "POST") {
      return res.status(403).send("Forbidden!");
    }

    const {from, to, subject, text}= req.body;
    const recipientEmail = Array.isArray(to) ? to[0] : to;

    if (!from || !recipientEmail || !subject || !text) {
      return res.status(400).send("Please provide all required fields.");
    }

    if (!validator.isEmail(from) || !validator.isEmail(recipientEmail)) {
      return res.status(400).send("Invalid email address.");
    }

    const mailOptions = {
      from,
      to: recipientEmail,
      subject,
      text,
    };

    try {
      const info = await transporter.sendMail(mailOptions);
      console.log("Email sent:", info.response);
      return res.status(200).send("Email sent: " + info.response);
    } catch (error) {
      console.error("Error sending email:", error);
      return res.status(500).send(error.toString());
    }
  });
});
