import {detectClones} from "jscpd";
import {IMapFrame, MemoryStore} from "@jscpd/core";

(async () => {
  const store = new MemoryStore<IMapFrame>();

  // detectClones
  await detectClones({
    path: [
      __dirname + '/../fixtures'
    ],
  }, store);

  // detectClones
  await detectClones({
    path: [
      __dirname + '/../fixtures'
    ],
    silent: true
  }, store);
})()
