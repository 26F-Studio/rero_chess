namespace Zenitha {
  export type Color = [number, number, number, number?];
  export interface drawingCommand {
    _help?: Graphics.drawingCommandType;
    [1]: Graphics.drawingCommandType;
    [key: number]: any;
  }
  namespace Graphics {
    export type drawingCommandType =
      | "push"
      | "pop"
      | "repT"
      | "appT"
      | "invT"
      | "origin"
      | "move"
      | "scale"
      | "rotate"
      | "shear"
      | "clear"
      | "setCL"
      | "setCM"
      | "setLW"
      | "setLS"
      | "setLJ"
      | "setBM"
      | "setSD"
      | "print"
      | "rawFT"
      | "setFT"
      | "mStr"
      | "mDraw"
      | "mDrawQ"
      | "mDrawL"
      | "mDrawLQ"
      | "stStr"
      | "stDraw"
      | "draw"
      | "drawL"
      | "line"
      | "fRect"
      | "dRect"
      | "fCirc"
      | "dCirc"
      | "fElps"
      | "dElps"
      | "fPoly"
      | "dPoly"
      | "dPie"
      | "dArc"
      | "dBow"
      | "fPie"
      | "fArc"
      | "fBow"
      | "fMRect"
      | "dMRect"
      | "fRPol"
      | "dRPol"
      | "fRRPol"
      | "dRRPol";
    export type drawingCommand = {
      type: drawingCommandType;
      args: any[];
    };
    export type drawingCommandList = drawingCommand[];
  }
}

export interface CellData {
  id: number;
  x?: number;
  y?: number;
  dx?: number;
  dy?: number;
  props: Prop[];
  extra: {
    [key: string]: any;
  };
}

export interface PlayerData {
  name: string;
  skin?: string;
  startLocation?: number | string;
  startMoveDir?: "next" | "prev";
  size?: number;
  color?: Zenitha.Color;
  dicePoints?: number[];
  diceWeights?: number[];
}

export interface MapData {
  texturePack?: string;
  playerData: PlayerData[];
  decoData: Zenitha.drawingCommand[];
  mapData: CellData[];
  seed?: number;
}

export enum PlayerRef {
  self = "@self",
  spec = "@spec",
  spec_ex = "@spec_ex",
  spec_free = "@spec_free",
  spec_free_ex = "@spec_free_ex",
  spec_trap = "@spec_trap",
  spec_trap_ex = "@spec_trap_ex",
  random = "@random",
  random_ex = "@random_ex",
  nearest = "@nearest",
  farthest = "@farthest",
  front = "@front",
  behind = "@behind",
  next = "@next",
  prev = "@prev",
  first = "@first",
  last = "@last",
}

export enum PropType {
  label = "label",
  next = "next",
  center = "center",
  text = "text",
  step = "step",
  move = "move",
  teleport = "teleport",
  stop = "stop",
  reverse = "reverse",
  diceMod = "diceMod",
  exTurn = "exTurn",
  swap = "swap",
  exit = "exit",
}

export enum DiceModifier {
  add = "+",
  divide = "/",
  multiply = "*",
  power = "^",
  substract = "-",
}

export interface LabelProp {
  type: PropType.label;
  data: string;
}

export interface NextProp {
  type: PropType.next;
  data: (string | number)[];
}

export interface CenterProp {
  type: PropType.center;
}

export interface TextProp {
  type: PropType.text;
  data: string;
}

export interface StepProp {
  type: PropType.step;
  data: number;
}

export interface MoveProp {
  type: PropType.move;
  data: {
    count: number;
    target: PlayerRef;
  };
}

export interface TeleportProp {
  type: PropType.teleport;
  data: {
    count: string | number;
    target: PlayerRef;
  };
}

export interface StopProp {
  type: PropType.stop;
}
export interface ReverseProp {
  type: PropType.reverse;
}
export interface DiceModProp {
  type: PropType.diceMod;
  data: {
    modifier: DiceModifier;
    value: number;
  };
}
export interface ExTurnProp {
  type: PropType.exTurn;
  data: number;
}
export interface SwapProp {
  type: PropType.swap;
  data: {
    first: PlayerRef;
    second: PlayerRef;
  };
}
export interface ExitProp {
  type: PropType.exit;
  data: {
    target: PlayerRef;
    trapId: string;
    destination: string;
  };
}
export type Prop =
  | LabelProp
  | NextProp
  | CenterProp
  | TextProp
  | StepProp
  | MoveProp
  | TeleportProp
  | StopProp
  | ReverseProp
  | DiceModProp
  | ExTurnProp
  | SwapProp
  | ExitProp;

export interface CheckpointConfig {
  probability: number;
  convertion?: {
    rate: number;
    ratio: {
      dice: number;
      extraTurns: number;
      reverse: number;
    };
  };
}

export interface GenerateConfig {
  mainLength: number;
  difficulty: number;
  gap: {
    min: number;
    max: number;
  };
  checkpoints: CheckpointConfig[];
}
