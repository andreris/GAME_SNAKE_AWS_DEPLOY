const board = document.querySelector("#game-board");
const context = board.getContext("2d");
const scoreElement = document.querySelector("#score");
const bestScoreElement = document.querySelector("#best-score");
const levelElement = document.querySelector("#level");
const statusLine = document.querySelector("#status-line");
const overlay = document.querySelector("#game-overlay");
const overlayKicker = document.querySelector("#overlay-kicker");
const overlayTitle = document.querySelector("#overlay-title");
const overlayCopy = document.querySelector("#overlay-copy");
const overlayAction = document.querySelector("#overlay-action");
const startButton = document.querySelector("#start-button");
const pauseButton = document.querySelector("#pause-button");
const resetButton = document.querySelector("#reset-button");
const directionButtons = document.querySelectorAll("[data-direction]");

const cellCount = 22;
const initialSnake = [
  { x: 10, y: 11 },
  { x: 9, y: 11 },
  { x: 8, y: 11 },
];
const directions = {
  up: { x: 0, y: -1 },
  down: { x: 0, y: 1 },
  left: { x: -1, y: 0 },
  right: { x: 1, y: 0 },
};
const directionKeys = {
  ArrowUp: "up",
  KeyW: "up",
  ArrowDown: "down",
  KeyS: "down",
  ArrowLeft: "left",
  KeyA: "left",
  ArrowRight: "right",
  KeyD: "right",
};
const palette = {
  background: "#0f172a",
  grid: "#243b53",
  snake: "#00f5a0",
  snakeHead: "#63ffda",
  food: "#ff2e63",
  reward: "#ffe45e",
  text: "#f8fafc",
};
const emoji = {
  mouse: "\uD83D\uDC2D",
  rabbit: "\uD83D\uDC30",
  eagle: "\uD83E\uDD85",
  bush: "\uD83C\uDF33",
};
const initialBushCount = 8;
const bushesPerLevel = 2;
const maxBushes = 22;
const eagleStartLevel = 2;
const eagleStepMs = 260;
const eagleChaseChance = 0.72;
const bonusSpawnChance = 0.28;
const bonusLifetimeMs = 6500;
const bonusPoints = 25;
const foodPoints = 10;

let snake = [];
let food = { x: 14, y: 11 };
let bonus = null;
let bushes = [];
let eagle = null;
let direction = directions.right;
let nextDirection = directions.right;
let score = 0;
let level = 1;
let status = "idle";
let lastFrameTime = 0;
let stepInterval = 150;
let touchStart = null;
let bestScore = Number(localStorage.getItem("snake-best-score") || 0);

bestScoreElement.textContent = String(bestScore);

function resetGame() {
  snake = initialSnake.map((segment) => ({ ...segment }));
  direction = directions.right;
  nextDirection = directions.right;
  score = 0;
  level = 1;
  stepInterval = 150;
  bushes = createBushes(initialBushCount);
  food = createFood();
  bonus = null;
  eagle = null;
  updateHud("Listo", false);
  drawGame();
}

function startGame() {
  if (status === "running") {
    return;
  }

  if (status === "idle" || status === "ended") {
    resetGame();
  }

  status = "running";
  overlay.classList.add("is-hidden");
  pauseButton.disabled = false;
  pauseButton.textContent = "Pausa";
  updateHud("Jugando", false);
  lastFrameTime = performance.now();
  requestAnimationFrame(gameLoop);
}

function pauseGame() {
  if (status === "running") {
    status = "paused";
    pauseButton.textContent = "Seguir";
    showOverlay("Pausa", "Viborita", "El juego esta detenido.", "Seguir");
    updateHud("Pausa", false);
    return;
  }

  if (status === "paused") {
    startGame();
  }
}

function endGame() {
  status = "ended";
  pauseButton.disabled = true;
  pauseButton.textContent = "Pausa";
  updateBestScore();
  showOverlay("Fin", "Juego terminado", `Puntaje ${score}`, "Reintentar");
  updateHud("Choque", true);
}

function gameLoop(timestamp) {
  if (status !== "running") {
    return;
  }

  if (timestamp - lastFrameTime >= stepInterval) {
    updateGame();
    lastFrameTime = timestamp;
  }

  updateEagle(timestamp);
  updateBonus(timestamp);

  if (status !== "running") {
    return;
  }

  drawGame();
  requestAnimationFrame(gameLoop);
}

function updateGame() {
  direction = nextDirection;
  const head = snake[0];
  const nextHead = {
    x: head.x + direction.x,
    y: head.y + direction.y,
  };
  const eatsFood = nextHead.x === food.x && nextHead.y === food.y;
  const eatsBonus = bonus !== null && nextHead.x === bonus.x && nextHead.y === bonus.y;

  if (hasCollision(nextHead, eatsFood || eatsBonus)) {
    endGame();
    return;
  }

  snake.unshift(nextHead);

  if (eatsFood) {
    handleScoreGain(foodPoints);
    food = createFood();
    maybeSpawnBonus();
    updateHud("Raton", false);
    return;
  }

  if (eatsBonus) {
    handleScoreGain(bonusPoints);
    bonus = null;
    updateHud("Bonus conejo", false);
    return;
  }

  snake.pop();
  updateHud("Jugando", false);
}

function handleScoreGain(points) {
  const previousLevel = level;
  score += points;
  level = Math.floor(score / 50) + 1;
  stepInterval = Math.max(78, 150 - (level - 1) * 9);

  if (level > previousLevel) {
    handleLevelUp();
  }
}

function handleLevelUp() {
  const extra = createBushes(bushesPerLevel, bushes);
  bushes = bushes.concat(extra).slice(0, maxBushes);

  if (eagle === null && level >= eagleStartLevel) {
    eagle = spawnEagle(performance.now());
  }
}

function hasCollision(point, grows) {
  const outsideBoard = point.x < 0 || point.x >= cellCount || point.y < 0 || point.y >= cellCount;
  if (outsideBoard) {
    return true;
  }
  const occupiedBody = grows ? snake : snake.slice(0, -1);
  const hitsSelf = occupiedBody.some((segment) => segment.x === point.x && segment.y === point.y);
  const hitsBush = bushes.some((bush) => bush.x === point.x && bush.y === point.y);
  const hitsEagle = eagle !== null && eagle.x === point.x && eagle.y === point.y;
  return hitsSelf || hitsBush || hitsEagle;
}

function createFood() {
  return pickFreeCell({ avoidBonus: true, avoidEagle: true });
}

function maybeSpawnBonus() {
  if (bonus !== null) {
    return;
  }
  if (Math.random() > bonusSpawnChance) {
    return;
  }

  const spot = pickFreeCell({ avoidFood: true, avoidEagle: true });
  if (spot === null) {
    return;
  }

  bonus = { x: spot.x, y: spot.y, expiresAt: performance.now() + bonusLifetimeMs };
}

function updateBonus(timestamp) {
  if (bonus !== null && timestamp >= bonus.expiresAt) {
    bonus = null;
  }
}

function createBushes(count, existing = []) {
  const result = [];
  const safeRadius = 4;
  const start = (snake && snake[0]) || { x: Math.floor(cellCount / 2), y: Math.floor(cellCount / 2) };

  for (let attempt = 0; attempt < count * 30 && result.length < count; attempt += 1) {
    const candidate = {
      x: Math.floor(Math.random() * cellCount),
      y: Math.floor(Math.random() * cellCount),
    };
    const tooClose = Math.abs(candidate.x - start.x) + Math.abs(candidate.y - start.y) < safeRadius;
    const collides =
      tooClose ||
      snake.some((segment) => segment.x === candidate.x && segment.y === candidate.y) ||
      (food && food.x === candidate.x && food.y === candidate.y) ||
      existing.some((bush) => bush.x === candidate.x && bush.y === candidate.y) ||
      result.some((bush) => bush.x === candidate.x && bush.y === candidate.y);

    if (!collides) {
      result.push(candidate);
    }
  }

  return result;
}

function spawnEagle(timestamp) {
  const spot = pickFreeCell({ avoidFood: true, avoidBonus: true, minDistance: 8 });
  if (spot === null) {
    return null;
  }
  return { x: spot.x, y: spot.y, lastStepAt: timestamp };
}

function updateEagle(timestamp) {
  if (eagle === null) {
    return;
  }
  if (timestamp - eagle.lastStepAt < eagleStepMs) {
    return;
  }

  const head = snake[0];
  const candidates = Object.values(directions)
    .map((delta) => ({ x: eagle.x + delta.x, y: eagle.y + delta.y }))
    .filter((point) => point.x >= 0 && point.x < cellCount && point.y >= 0 && point.y < cellCount)
    .filter((point) => !bushes.some((bush) => bush.x === point.x && bush.y === point.y));

  if (candidates.length === 0) {
    eagle.lastStepAt = timestamp;
    return;
  }

  let next;
  if (Math.random() < eagleChaseChance) {
    next = candidates.reduce((best, current) => {
      const bestDistance = Math.abs(best.x - head.x) + Math.abs(best.y - head.y);
      const currentDistance = Math.abs(current.x - head.x) + Math.abs(current.y - head.y);
      return currentDistance < bestDistance ? current : best;
    });
  } else {
    next = candidates[Math.floor(Math.random() * candidates.length)];
  }

  eagle.x = next.x;
  eagle.y = next.y;
  eagle.lastStepAt = timestamp;

  if (snake.some((segment) => segment.x === eagle.x && segment.y === eagle.y)) {
    endGame();
  }
}

function pickFreeCell(options) {
  const settings = options || {};
  const avoidFood = settings.avoidFood === true;
  const avoidBonus = settings.avoidBonus === true;
  const avoidEagle = settings.avoidEagle === true;
  const minDistance = settings.minDistance || 0;
  const head = snake[0];
  const freeCells = [];

  for (let y = 0; y < cellCount; y += 1) {
    for (let x = 0; x < cellCount; x += 1) {
      if (snake.some((segment) => segment.x === x && segment.y === y)) continue;
      if (bushes.some((bush) => bush.x === x && bush.y === y)) continue;
      if (avoidFood && food && food.x === x && food.y === y) continue;
      if (avoidBonus && bonus && bonus.x === x && bonus.y === y) continue;
      if (avoidEagle && eagle && eagle.x === x && eagle.y === y) continue;
      if (head && minDistance > 0 && Math.abs(head.x - x) + Math.abs(head.y - y) < minDistance) continue;
      freeCells.push({ x, y });
    }
  }

  if (freeCells.length === 0) {
    return null;
  }
  return freeCells[Math.floor(Math.random() * freeCells.length)];
}

function setDirection(name) {
  const selectedDirection = directions[name];
  const wouldReverse = selectedDirection.x + direction.x === 0 && selectedDirection.y + direction.y === 0;

  if (!wouldReverse) {
    nextDirection = selectedDirection;
  }
}

function drawGame() {
  const size = board.width;
  const cellSize = size / cellCount;

  context.clearRect(0, 0, size, size);
  context.fillStyle = palette.background;
  context.fillRect(0, 0, size, size);
  drawGrid(cellSize, size);
  drawBushes(cellSize);
  drawFood(cellSize);
  drawBonus(cellSize);
  drawEagle(cellSize);
  drawSnake(cellSize);
}

function drawGrid(cellSize, size) {
  context.strokeStyle = palette.grid;
  context.globalAlpha = 0.42;
  context.lineWidth = 1;

  for (let index = 0; index <= cellCount; index += 1) {
    const position = index * cellSize;
    context.beginPath();
    context.moveTo(position, 0);
    context.lineTo(position, size);
    context.moveTo(0, position);
    context.lineTo(size, position);
    context.stroke();
  }

  context.globalAlpha = 1;
}

function drawFood(cellSize) {
  drawEmoji(emoji.mouse, food.x, food.y, cellSize, palette.food, 14);
}

function drawBonus(cellSize) {
  if (bonus === null) {
    return;
  }

  const remaining = Math.max(0, bonus.expiresAt - performance.now());
  const isBlinking = remaining < 2000;
  if (isBlinking && Math.floor(remaining / 180) % 2 === 0) {
    return;
  }

  drawEmoji(emoji.rabbit, bonus.x, bonus.y, cellSize, palette.reward, 18);
}

function drawBushes(cellSize) {
  bushes.forEach((bush) => {
    drawEmoji(emoji.bush, bush.x, bush.y, cellSize, "#1f4d2b", 8);
  });
}

function drawEagle(cellSize) {
  if (eagle === null) {
    return;
  }
  drawEmoji(emoji.eagle, eagle.x, eagle.y, cellSize, "#ff9a00", 20);
}

function drawEmoji(symbol, cellX, cellY, cellSize, glowColor, glowBlur) {
  const centerX = cellX * cellSize + cellSize / 2;
  const centerY = cellY * cellSize + cellSize / 2;

  context.save();
  context.font = `${Math.floor(cellSize * 0.86)}px "Segoe UI Emoji", "Apple Color Emoji", "Noto Color Emoji", sans-serif`;
  context.textAlign = "center";
  context.textBaseline = "middle";
  context.shadowColor = glowColor;
  context.shadowBlur = glowBlur;
  context.fillText(symbol, centerX, centerY);
  context.restore();
}

function drawSnake(cellSize) {
  snake.forEach((segment, index) => {
    const inset = cellSize * 0.12;
    const x = segment.x * cellSize + inset;
    const y = segment.y * cellSize + inset;
    const size = cellSize - inset * 2;
    const isHead = index === 0;

    context.save();
    context.shadowColor = isHead ? palette.snakeHead : palette.snake;
    context.shadowBlur = isHead ? 16 : 10;
    context.fillStyle = isHead ? palette.snakeHead : palette.snake;
    roundRect(context, x, y, size, size, Math.max(5, cellSize * 0.2));
    context.fill();

    if (isHead) {
      drawEyes(segment, cellSize);
    }

    context.restore();
  });
}

function drawEyes(head, cellSize) {
  const centerX = head.x * cellSize + cellSize / 2;
  const centerY = head.y * cellSize + cellSize / 2;
  const offsetX = direction.x * cellSize * 0.16;
  const offsetY = direction.y * cellSize * 0.16;
  const sideX = direction.y * cellSize * 0.16;
  const sideY = -direction.x * cellSize * 0.16;

  context.fillStyle = "#0b1026";
  context.beginPath();
  context.arc(centerX + offsetX + sideX, centerY + offsetY + sideY, cellSize * 0.06, 0, Math.PI * 2);
  context.arc(centerX + offsetX - sideX, centerY + offsetY - sideY, cellSize * 0.06, 0, Math.PI * 2);
  context.fill();
}

function roundRect(drawingContext, x, y, width, height, radius) {
  drawingContext.beginPath();
  drawingContext.moveTo(x + radius, y);
  drawingContext.lineTo(x + width - radius, y);
  drawingContext.quadraticCurveTo(x + width, y, x + width, y + radius);
  drawingContext.lineTo(x + width, y + height - radius);
  drawingContext.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
  drawingContext.lineTo(x + radius, y + height);
  drawingContext.quadraticCurveTo(x, y + height, x, y + height - radius);
  drawingContext.lineTo(x, y + radius);
  drawingContext.quadraticCurveTo(x, y, x + radius, y);
}

function updateHud(message, isDanger) {
  scoreElement.textContent = String(score);
  levelElement.textContent = String(level);
  statusLine.textContent = message;
  statusLine.classList.toggle("is-danger", isDanger);
}

function updateBestScore() {
  if (score <= bestScore) {
    return;
  }

  bestScore = score;
  localStorage.setItem("snake-best-score", String(bestScore));
  bestScoreElement.textContent = String(bestScore);
}

function showOverlay(kicker, title, copy, action) {
  overlayKicker.textContent = kicker;
  overlayTitle.textContent = title;
  overlayCopy.textContent = copy;
  overlayAction.textContent = action;
  overlay.classList.remove("is-hidden");
}

function resizeBoard() {
  const rect = board.getBoundingClientRect();
  board.width = Math.floor(rect.width);
  board.height = Math.floor(rect.height);
  drawGame();
}

function handleTouchStart(event) {
  const touch = event.changedTouches[0];
  touchStart = { x: touch.clientX, y: touch.clientY };
}

function handleTouchEnd(event) {
  if (touchStart === null) {
    return;
  }

  const touch = event.changedTouches[0];
  const deltaX = touch.clientX - touchStart.x;
  const deltaY = touch.clientY - touchStart.y;
  const horizontal = Math.abs(deltaX) > Math.abs(deltaY);

  if (Math.max(Math.abs(deltaX), Math.abs(deltaY)) < 24) {
    touchStart = null;
    return;
  }

  setDirection(horizontal ? (deltaX > 0 ? "right" : "left") : (deltaY > 0 ? "down" : "up"));
  touchStart = null;
}

window.addEventListener("keydown", (event) => {
  if (event.code === "Space") {
    event.preventDefault();
    pauseGame();
    return;
  }

  const directionName = directionKeys[event.code];
  if (directionName) {
    event.preventDefault();
    setDirection(directionName);
  }
});

window.addEventListener("resize", resizeBoard);
board.addEventListener("touchstart", handleTouchStart, { passive: true });
board.addEventListener("touchend", handleTouchEnd, { passive: true });
startButton.addEventListener("click", startGame);
overlayAction.addEventListener("click", startGame);
pauseButton.addEventListener("click", pauseGame);
resetButton.addEventListener("click", () => {
  status = "idle";
  pauseButton.disabled = true;
  pauseButton.textContent = "Pausa";
  resetGame();
  showOverlay("Listo", "Viborita", "Come ratones, esquiva arbustos y huye del aguila.", "Jugar");
});
directionButtons.forEach((button) => {
  button.addEventListener("click", () => setDirection(button.dataset.direction));
});

resetGame();
resizeBoard();