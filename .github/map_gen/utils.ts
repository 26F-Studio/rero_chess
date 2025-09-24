import {
  CellData,
  CheckpointConfig,
  DiceModifier,
  DiceModProp,
  GenerateConfig,
  MapData,
  PropType,
} from "./types";

const validateConfig = (config: GenerateConfig) => {
  if (config.mainLength < 1) {
    throw new Error("mainLength must be >= 1");
  }
  if (config.minDiceRequirement < 1) {
    throw new Error("minDiceRequirement must be >= 1");
  }
  if (config.checkpoints.length === 0) {
    throw new Error("checkpoints must not be empty");
  }
  if (
    config.checkpoints.some(
      (checkpoint) => checkpoint.probability < 0 || checkpoint.probability > 1
    )
  ) {
    throw new Error("checkpoint.probability must be >= 0 and <= 1");
  }
};

const generateDiceModProp = (
  config: GenerateConfig
): { prop: DiceModProp; newGapMax: number } => {
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
        Math.floor(Math.random() * (gap.max - gap.min)),
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

const constructMainPath = (pathLength: number) => {
  return Array.from({ length: pathLength }, (_, index) => {
    const cell: CellData & { data?: object } = {
      id: index,
      props: [],
      extra: {},
    };

    if (index === 0) {
      cell.props.push(
        {
          type: PropType.label,
          data: "begin",
        },
        {
          type: PropType.text,
          data: "起点",
        }
      );
      cell.extra.checkpointLevel = 0;
    } else if (index === pathLength - 1) {
      cell.props.push(
        {
          type: PropType.label,
          data: "end",
        },
        {
          type: PropType.text,
          data: "终点",
        }
      );
      cell.extra.checkpointLevel = 0;
    }

    return cell;
  });
};

const initCheckpoints = (map: CellData[], config: GenerateConfig) => {
  const { probability } = config.checkpoints[0];
  if (probability < 0 || probability > 1) {
    throw new Error("The first checkpoint probability must be between 0 and 1");
  }
  let gapCounter = 0;
  for (const cell of map.slice(1, -1)) {
    if (
      (gapCounter > config.gap.min && Math.random() < probability) ||
      gapCounter >= config.gap.max
    ) {
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

const convertCheckpoints = (
  map: CellData[],
  checkpointConfigs: CheckpointConfig[]
) => {
  for (const [level, config] of checkpointConfigs.entries()) {
    const { convertion } = config;
    if (!convertion) {
      continue;
    }

    const cellsWithCheckpoint = map.filter(
      (cell) => cell.extra?.checkpointLevel === level
    );
    for (const [index, cell] of cellsWithCheckpoint.entries()) {
      if (Math.random() < convertion.rate) {
        const convertionValue =
          Math.random() *
          Object.values(convertion.ratio).reduce((acc, cur) => acc + cur, 0);
        if (convertionValue < convertion.ratio.dice) {
          const { prop, newGapMax } = generateDiceModProp({
            min: 1,
            max: (cellsWithCheckpoint[index + 1]?.id ?? map.length) - cell.id,
          });
          cell.props?.push(prop);
        } else if (
          convertionValue <
          convertion.ratio.dice + convertion.ratio.extraTurns
        ) {
          cell.props?.push({
            type: PropType.exTurn,
            data: Math.floor(Math.sin((Math.random() * Math.PI) / 2) * 3) + 1,
          });
        } else {
          cell.props?.push({
            type: PropType.reverse,
          });
        }
      }
    }
  }
};

const fillNormalCells = (
  cellDataList: CellData[],
  config: GenerateConfig
) => {};

export const generateMap = (config: GenerateConfig): MapData => {
  validateConfig(config);

  const seed = config.seed ?? Math.floor(Math.random() * 1000000);
  const cellDataList = constructMainPath(config.mainLength);
  initCheckpoints(cellDataList, config);
  convertCheckpoints(cellDataList, config.checkpoints);

  return {
    playerData: [],
    decoData: [],
    mapData: cellDataList,
    seed,
  };
};
