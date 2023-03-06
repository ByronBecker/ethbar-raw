import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface CDN {
  'getCanisterMetrics' : ActorMethod<[], CanisterMetrics>,
  'getRBTElementsCount' : ActorMethod<[], bigint>,
  'getRBTreeItem' : ActorMethod<[string], [] | [Array<number>]>,
  'hasItemWithKey' : ActorMethod<[string], [] | [string]>,
  'uploadChunk' : ActorMethod<[string, Array<number>], bigint>,
}
export interface CanisterMetrics { 'heapSize' : bigint, 'cycles' : bigint }
export interface _SERVICE extends CDN {}
