## Map data of Rero Chess

### Map data definitions written in Typescript

```typescript
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

namespace ReroChess {
  export type CellData = {
    id: number;
    x?: number;
    y?: number;
    dx?: number;
    dy?: number;
    prop?: string;
  };

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
    playerData: ReroChess.PlayerData[];
    decoData: Zenitha.drawingCommand[];
    mapData: ReroChess.CellData[];
    seed?: number;
  }
}
```
