import std/[strutils, tables, asyncnet, asyncdispatch, monotimes, times, strformat]
import pkg/colors

import pangonim/http


proc processClient(client: AsyncSocket) {.async.} =
  let startTime = getMonoTime()

  var request = Request()
  let firstLine = await client.recvLine()
  echo firstLine

  # Proccess headers
  while true:
    let line = await client.recvLine()
    if line == END_OF_HEADERS: break

    let header = line.split(": ", maxsplit = 1)
    # echo header
    if header.len == 2:
      request.headers[header[0]] = header[1]
      
    
    if line.len == 0: break
    await client.send(line & "\n")
    # for c in clients:
    #   await c.send(line & "\c\L")
      
  # echo "END"
  echo request
  let elapsedTime = &"{getMonoTime() - startTime}"
  echo elapsedTime.green
  await client.send(&"\n{elapsedTime}")
  client.close()

proc serve() {.async.} =
  # clients = @[]
  var server = newAsyncSocket()
  server.setSockOpt(OptReuseAddr, true)
  server.bindAddr(Port(8080))
  let (ip, port) = server.getLocalAddr
  echo(cyan(&"\nListening on http://{ip}:{uint16(port)}").bold)
  server.listen()

  
  while true:
    let client = await server.accept()
    echo "New client"
    # clients.add client
    
    asyncCheck processClient client

when isMainModule:
  asyncCheck serve()
  runForever()