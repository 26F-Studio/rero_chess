import { generateMap } from "./utils";

console.log("Generating map...");
const map = generateMap({
  mainLength: 30,
  difficulty: 0.5,
  gap: { min: 1, max: 6 },
  checkpoints: [{ probability: 0.2 }],
});
console.log(JSON.stringify(map, undefined, 2));
