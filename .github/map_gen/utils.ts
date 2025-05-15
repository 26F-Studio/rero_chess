import {
  CellData,
  CheckpointConfig,
  DiceModifier,
  DiceModProp,
  GenerateConfig,
  PropType,
} from "./types";

const generateDiceModProp = (gap: {
  min?: number;
  max: number;
}): { prop: DiceModProp; newGapMax: number } => {
  switch (Math.floor(Math.random() * 5)) {
    case 0: {
      const value = Math.floor(Math.random() * gap.max) + 1;
      return {
        prop: {
          type: PropType.diceMod,
          data: {
            modifier: DiceModifier.add,
            value,
          },
        },
        newGapMax: gap.max + value,
      };
    }
    case 1: {
      const value = 1 + Math.random() * (gap.max - 1);
      return {
        prop: {
          type: PropType.diceMod,
          data: {
            modifier: DiceModifier.divide,
            value,
          },
        },
        newGapMax: Math.ceil(gap.max * (1 + value)),
      };
    }
    case 2: {
      const value = 1 + Math.random() * (gap.max - 1);
      return {
        prop: {
          type: PropType.diceMod,
          data: {
            modifier: DiceModifier.multiply,
            value,
          },
        },
        newGapMax: Math.floor(gap.max * (1 + value)),
      };
    }
    case 3: {
      const value = Math.max(Math.random() * Math.log(gap.max), 1);
      return {
        prop: {
          type: PropType.diceMod,
          data: {
            modifier: DiceModifier.power,
            value,
          },
        },
        newGapMax: Math.round(gap.max ** value),
      };
    }
    default: {
      const value = Math.min(
        Math.floor(Math.random() * (gap.max - (gap.min ?? 0))),
        gap.max - 1
      );
      return {
        prop: {
          type: PropType.diceMod,
          data: {
            modifier: DiceModifier.substract,
            value,
          },
        },
        newGapMax: gap.max - value,
      };
    }
  }
};

const initRootCheckpoint = (map: CellData[], config: GenerateConfig) => {
  const { probability } = config.checkpoints[0];
  if (probability < 0 || probability > 1) {
    throw new Error("The first checkpoint probability must be between 0 and 1");
  }
  let gapCounter = 0;
  for (const [index, cell] of map.entries()) {
    cell.id = index;
    if (Math.random() < probability || gapCounter >= config.gap.max) {
      cell.extra = {
        checkpointLevel: 0,
      };
      gapCounter = 0;
    } else {
      gapCounter++;
    }
  }

  let checkpointLevel = 0;
  for (const checkpointConfig of config.checkpoints.slice(1)) {
    const { probability } = checkpointConfig;
    const cellsWithCheckpoint = map.filter(
      (cell) => cell.extra?.checkpointLevel === checkpointLevel
    );
    for (const cell of cellsWithCheckpoint) {
      if (Math.random() < probability) {
        cell.extra.checkpointLevel = checkpointLevel + 1;
      }
    }
    checkpointLevel++;
  }
};

export const generateMap = (config: GenerateConfig) => {
  if (config.mainLength < 1) {
    throw new Error("mainLength must >= 1");
  }
  if (config.gap.min < 0 || config.gap.max < 1) {
    throw new Error("gap.min must >= 0, gap.max must >= 1");
  }
  if (config.gap.min > config.gap.max) {
    throw new Error("gap.min must > gap.max");
  }
  if (config.checkpoints.length === 0) {
    throw new Error("checkpoints must not be empty");
  }
  if (
    config.checkpoints.some(
      (checkpoint) => checkpoint.probability < 0 || checkpoint.probability > 1
    )
  ) {
    throw new Error("checkpoint.probability must >= 0 and <= 1");
  }

  const map = new Array<CellData & { data?: object }>(config.mainLength).fill({
    id: -1,
    props: [],
    extra: {},
  });
  initRootCheckpoint(map, config);
  
  // const { convertion, probability } = sortedCheckpoints[0];

  // let currentGapConfig = config.gap;
  // let gapCounter = 0;
  // for (const [index, cell] of map.entries()) {
  //   cell.id = index;
  //   if (Math.random() < probability || gapCounter >= currentGapConfig.max) {
  //     if (convertion && Math.random() < convertion.rate) {
  //       const convertionValue =
  //         Math.random() *
  //         Object.values(convertion.ratio).reduce((acc, cur) => acc + cur, 0);
  //       if (convertionValue < convertion.ratio.dice) {
  //         const { prop, newGapMax } = generateDiceModProp(currentGapConfig);
  //         cell.props?.push(prop);
  //         if (Math.random() < config.difficulty) {
  //           currentGapConfig.max = newGapMax;
  //         }
  //       } else if (
  //         convertionValue <
  //         convertion.ratio.dice + convertion.ratio.extraTurns
  //       ) {
  //         cell.props?.push({
  //           type: PropType.exTurn,
  //           data: Math.floor(Math.sin((Math.random() * Math.PI) / 2) * 3) + 1,
  //         });
  //       } else {
  //         cell.props?.push({
  //           type: PropType.reverse,
  //         });
  //       }
  //     }
  //     cell.data = {
  //       checkpointLevel: sortedCheckpoints[0].level,
  //     }
  //     gapCounter = 0;
  //   } else {
  //     // if (Math.random() < 0.5 * (1 + config.difficulty)) {
  //     //   cell.props?.push({
  //     //     type: PropType.step,
  //     //     data: Math.floor(Math.random() * 6) + 1,
  //     //   });
  //     // }
  //     gapCounter++;
  //   }
  // }
};
