import { createActor } from "candb-client-typescript/dist/createActor";
import { identityFromSeed } from "candb-client-typescript/dist/ClientUtil";
import { _SERVICE as RBTExp } from "../declarations/cdn/cdn.did"
import { idlFactory } from "../declarations/cdn";

import { readFileSync, writeFile } from 'fs';
import { resolve } from "path";
import { stringify } from "csv-stringify";
import { homedir } from "os";

type DataRow = {
  count: number;
  cycles: number;
  heapSizeMB: number;
}

const rows: DataRow[] = []
/**
 * Script for uploading video chunks (must be fragmented mp4) to the IC
 * 
 * Also calls an endpoint to fetch canister metrics
 */
async function go(isLocal: boolean) {
  const host = isLocal ? "http://127.0.0.1:8000" : "https://ic0.app";
  const canisterId = isLocal ? "r7inp-6aaaa-aaaaa-aaabq-cai" : "ew7pp-aaaaa-aaaan-qasiq-cai";
  const identity =  await identityFromSeed(`${homedir}/.config/dfx/identity/supernova/seed.txt`)

  const actor = createActor<RBTExp>({
    IDL: idlFactory,
    canisterId,
    agentOptions: {
      host,
      //identity,
    }
  });

  console.log("actor", actor);

  for (let i=1; i<11; i+=1) {
    const fileName = `eth_chunk_${i}`;
    let buffer = loadFile(fileName)
    try {
      let _ = await actor.uploadChunk(i.toString(), buffer)
      console.log("result", _)
      let metrics = await actor.getCanisterMetrics();
      rows.push({
        count: i,
        heapSizeMB: Number(metrics.heapSize),
        cycles: Number(metrics.cycles)
      });

      console.log("uploaded chunk #", i)
    } catch (err) {
      console.error(`error processing file: ${fileName}`);
      console.error(err);
    }
  };

  stringify(rows, {
    header: true,
    columns: [ 
      { key: "count", header: "Round/Count"},
      { key: "heapSizeMB", header: "Heap Size in MB"},
      { key: "cycles", header: "Cycles Remaining"},
    ]
  }, function(err, data) {
    writeFile("rows.csv", data, "utf-8", function(err) {
      if (err) {
        console.error("some error occurred writing files")
        console.log("data", data)
      } else {
        console.log("successfully wrote all data to rows.csv")
      }
    })
  })
}

function loadFile(fileName: string) {
  const filePath = resolve(__dirname, "../", fileName)
  console.log("resolved filePath", filePath)
  const buffer = readFileSync(filePath)
  return [...new Uint8Array(buffer)];
}

go(true);