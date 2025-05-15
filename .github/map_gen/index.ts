import { generateMap } from "./utils";

console.log("Generating map...");
console.log(
  generateMap({
    mainLength: 30,
    difficulty: 0.2,
    gap: { min: 1, max: 6 },
    checkpoints: [{ probability: 0.2 }],
  })
);
