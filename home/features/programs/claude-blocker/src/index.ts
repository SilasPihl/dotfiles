#!/usr/bin/env node
import { startServer } from "./server.js";
import { DEFAULT_PORT } from "./types.js";

const port = parseInt(process.env.CLAUDE_BLOCKER_PORT || "", 10) || DEFAULT_PORT;
startServer(port);
