import {spawn} from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import {pathToFileURL} from 'node:url';
const root=path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/,'$1'));
const browser=spawn('C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',['--headless=new','--disable-gpu','--no-first-run','--remote-debugging-pipe',`--user-data-dir=${path.resolve(root,'.browser-check')}`],{stdio:['ignore','ignore','pipe','pipe','pipe'],windowsHide:true});
let seq=0,buffer='',pending=new Map();
browser.stdio[4].on('data',chunk=>{buffer+=chunk.toString();let at;while((at=buffer.indexOf('\0'))>=0){let msg=JSON.parse(buffer.slice(0,at));buffer=buffer.slice(at+1);if(pending.has(msg.id)){let {resolve,reject}=pending.get(msg.id);pending.delete(msg.id);msg.error?reject(msg.error):resolve(msg.result)}}});
function send(method,params={},sessionId){return new Promise((resolve,reject)=>{let id=++seq;pending.set(id,{resolve,reject});browser.stdio[3].write(JSON.stringify({id,method,params,...(sessionId?{sessionId}:{})})+'\0')})}
const timer=setTimeout(()=>{browser.kill();process.exit(1)},45000);
try{
 const {targetId}=await send('Target.createTarget',{url:'about:blank'});const {sessionId}=await send('Target.attachToTarget',{targetId,flatten:true});const call=(m,p)=>send(m,p,sessionId);
 await call('Page.enable');await call('Page.navigate',{url:pathToFileURL(path.resolve(root,'toktik-arquitectura.html')).href});
 const run=async expression=>(await call('Runtime.evaluate',{expression,returnByValue:true,awaitPromise:true})).result.value;
 await run('new Promise(r=>document.readyState==="complete"?r():window.addEventListener("load",r,{once:true}))');
 const measurements=[];
 for(const [width,height]of [[1440,900],[1600,1000],[1920,1080],[2048,1320]]){await call('Emulation.setDeviceMetricsOverride',{width,height,deviceScaleFactor:1,mobile:false});measurements.push(await run('({width:innerWidth,height:innerHeight,scrollWidth:document.documentElement.scrollWidth,scrollHeight:document.documentElement.scrollHeight,nodes:document.querySelectorAll(".node").length})'));}
 const interactions=await run(`(()=>{show('tiktok');const endpoint=document.querySelector('#detail').textContent.includes('https://open.tiktokapis.com/v2/video/list/');document.querySelector('[data-mode="return"]').click();const returned=document.querySelector('.edge.request').classList.contains('hidden');document.querySelector('#simulate').click();const failure=document.querySelector('#node-tiktok').classList.contains('dim');document.querySelector('#simulate').click();show('repo');setMode('request');return {endpoint,returned,failure}})()`);
 await call('Emulation.setDeviceMetricsOverride',{width:1440,height:900,deviceScaleFactor:1,mobile:false});
 const shot=await call('Page.captureScreenshot',{format:'png',captureBeyondViewport:true});fs.writeFileSync(path.join(root,'toktik-preview.png'),Buffer.from(shot.data,'base64'));
 await run("setMode('return')");const returned=await call('Page.captureScreenshot',{format:'png',captureBeyondViewport:true});fs.writeFileSync(path.join(root,'toktik-return.png'),Buffer.from(returned.data,'base64'));
 await run("setMode('request');document.querySelector('#theme').click()");const light=await call('Page.captureScreenshot',{format:'png',captureBeyondViewport:true});fs.writeFileSync(path.join(root,'toktik-preview-light.png'),Buffer.from(light.data,'base64'));
 fs.writeFileSync(path.join(root,'explorer-browser-check.json'),JSON.stringify({measurements,interactions},null,2));console.log(JSON.stringify({measurements,interactions},null,2));
}finally{clearTimeout(timer);browser.kill()}
