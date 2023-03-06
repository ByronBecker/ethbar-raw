import { Client } from "./client"


async function getChunk(client: Client, id: number) {
  return client.getRBTreeItem(id.toString())
}

export async function getVideoUrl(client: Client, size: number) {
  let promises = Array.from(Array(size).keys())
    .map(i => {
      return i + 1
    })
    .map(i => getChunk(client, i)
  )
  const videoArray = (await Promise.all(promises))
    .filter(chunk => chunk.length > 0 && chunk[0].length > 0)
    .map(chunk => chunk[0] as unknown as Uint8Array)
  const blob = new Blob(videoArray, {type: 'video/mp4'});
  return URL.createObjectURL(blob);
}
  