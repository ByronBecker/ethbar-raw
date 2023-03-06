import { createActor } from "candb-client-typescript/dist/createActor";
import { _SERVICE as RBTExp } from "../declarations/cdn/cdn.did"
import { idlFactory } from "../declarations/cdn";

export type Client = ReturnType<typeof createChunkClient>

export function createChunkClient(isLocal: boolean) {
  const host = isLocal ? "http://127.0.0.1:8000" : "https://ic0.app";
  const canisterId = isLocal ? "r7inp-6aaaa-aaaaa-aaabq-cai" : "ew7pp-aaaaa-aaaan-qasiq-cai";

  return createActor<RBTExp>({
    IDL: idlFactory,
    canisterId,
    agentOptions: {
      host,
    }
  });
}