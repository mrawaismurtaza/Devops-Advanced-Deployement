const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();

const app = express();
app.use(express.json());
app.use(cors());

mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log("✅ MongoDB Connected"))
.catch(err => console.log(err));

const projectSchema = new mongoose.Schema({ 
  title: String, 
  description: String, 
  link: String 
});

const Project = mongoose.model("Project", projectSchema);

// Get all projects
app.get("/projects", async (req, res) => {
  const projects = await Project.find();
  res.json(projects);
});

// Add a new project
app.post("/projects", async (req, res) => {
  const newProject = new Project(req.body);
  await newProject.save();
  res.json(newProject);
});

app.listen(5000, () => console.log("🚀 Backend running on port 5000"));
