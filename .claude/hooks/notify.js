#!/usr/bin/env node
// Claude Code notification hook — port of ajoslin/dot opencode notification plugin.
// Supports multiple sound themes:
// - aoe: Assigns each session a unique AoE2 civilization via round-robin,
//        then plays a random villager sound from that civ on each event (default)
// - pokemon: Plays Charizard cry on each event

const { mkdir, readFile, writeFile, readdir } = require("node:fs/promises");
const { homedir } = require("node:os");
const { join } = require("node:path");
const { execFile } = require("node:child_process");

const soundsDir = join(homedir(), ".claude", "sounds");
const aoeSoundsDir = join(soundsDir, "aoe");
const pokemonSoundsDir = join(soundsDir, "pokemon");
const stateDir = join(homedir(), ".claude", "state", "notify");
const soundPoolPath = join(aoeSoundsDir, "aoe2_click_pool.json");
const configPath = join(soundsDir, "notify-config.json");
const soundThemePath = join(stateDir, "sound-theme.json");
const sessionMapPath = join(stateDir, "civ-session-map.json");
const lastIndexPath = join(stateDir, "civ-last-index.json");

// Default: only task and select sounds. Set to [] in config to use all sounds.
const DEFAULT_SOUND_TYPES = ["select", "task"];

let cachedSoundPool = null;
let cachedConfig = null;
let cachedSessionMap = null;
let cachedLastIndex = null;

async function ensureStateDir() {
  await mkdir(stateDir, { recursive: true });
}

async function readJson(filePath, fallback) {
  try {
    const contents = await readFile(filePath, "utf8");
    return JSON.parse(contents);
  } catch {
    return fallback;
  }
}

async function loadSoundPool() {
  if (!cachedSoundPool) {
    cachedSoundPool = await readJson(soundPoolPath, []);
  }
  return cachedSoundPool;
}

async function loadSessionMap() {
  if (!cachedSessionMap) {
    cachedSessionMap = await readJson(sessionMapPath, {});
  }
  return cachedSessionMap;
}

async function loadLastIndex() {
  if (cachedLastIndex === null) {
    const storedIndex = await readJson(lastIndexPath, -1);
    cachedLastIndex = Number.isInteger(storedIndex) ? storedIndex : -1;
  }
  return cachedLastIndex;
}

async function saveSessionMap(sessionMap) {
  await ensureStateDir();
  cachedSessionMap = sessionMap;
  await writeFile(sessionMapPath, JSON.stringify(sessionMap, null, 2));
}

async function saveLastIndex(index) {
  await ensureStateDir();
  cachedLastIndex = index;
  await writeFile(lastIndexPath, JSON.stringify(index));
}

async function getSessionInfo(sessionID) {
  if (!sessionID) return null;

  const soundPool = await loadSoundPool();
  if (!Array.isArray(soundPool) || soundPool.length === 0) return null;

  const sessionMap = await loadSessionMap();
  if (sessionMap[sessionID]) return sessionMap[sessionID];

  const lastIndex = await loadLastIndex();
  const nextIndex = (lastIndex + 1) % soundPool.length;
  const civ = soundPool[nextIndex];
  const gender = Math.random() < 0.5 ? "male" : "female";
  const entry = { civ, gender };
  sessionMap[sessionID] = entry;
  await saveSessionMap(sessionMap);
  await saveLastIndex(nextIndex);
  return entry;
}

async function loadConfig() {
  if (!cachedConfig) {
    cachedConfig = await readJson(configPath, {});
  }
  return cachedConfig;
}

async function loadSoundTheme() {
  const themeData = await readJson(soundThemePath, { theme: "aoe" });
  return themeData.theme || "aoe";
}

async function playPokemonSound() {
  try {
    const files = await readdir(pokemonSoundsDir);
    const audioFiles = files.filter(
      (f) => f.endsWith(".ogg") || f.endsWith(".mp3")
    );
    if (audioFiles.length === 0) return;
    const pick = audioFiles[Math.floor(Math.random() * audioFiles.length)];
    await playSound(join(pokemonSoundsDir, pick));
  } catch {
    return;
  }
}

async function getRandomVillagerSound(civ, gender) {
  const civDir = join(aoeSoundsDir, civ.toLowerCase());
  const config = await loadConfig();
  const soundTypes = config.soundTypes || DEFAULT_SOUND_TYPES;
  try {
    const files = await readdir(civDir);
    let audioFiles = files.filter(
      (f) => (f.endsWith(".ogg") || f.endsWith(".mp3")) && f.includes(`_${gender}_`)
    );
    if (soundTypes.length > 0) {
      audioFiles = audioFiles.filter((f) =>
        soundTypes.some((type) => f.includes(`_${type}`))
      );
    }
    if (audioFiles.length === 0) return null;
    const pick = audioFiles[Math.floor(Math.random() * audioFiles.length)];
    return join(civDir, pick);
  } catch {
    return null;
  }
}

function playSound(soundPath) {
  return new Promise((resolve) => {
    execFile(
      "ffplay",
      ["-nodisp", "-autoexit", "-loglevel", "quiet", soundPath],
      (err) => resolve()
    );
  });
}

async function playAoeSound(sessionID) {
  const info = await getSessionInfo(sessionID);
  if (!info) return;

  const soundPath = await getRandomVillagerSound(info.civ, info.gender);
  if (soundPath) {
    await playSound(soundPath);
  }
}

async function main() {
  let input = "";
  for await (const chunk of process.stdin) {
    input += chunk;
  }

  let data = {};
  try {
    data = JSON.parse(input);
  } catch {
    process.exit(0);
  }

  if (data.stop_hook_active) {
    process.exit(0);
  }

  const sessionID = data.session_id;
  if (!sessionID) {
    process.exit(0);
  }

  // Load sound theme preference (defaults to aoe)
  const theme = await loadSoundTheme();

  if (theme === "aoe") {
    await playAoeSound(sessionID);
  } else {
    // Default to pokemon
    await playPokemonSound();
  }
}

main().then(() => process.exit(0)).catch(() => process.exit(0));
