export type Ride = { id:string; driver:string; initials:string; from:string; to:string; date:string; time:string; seats:number; price:number; car:string; rating:number; verified:boolean; notes:string; tags:string[]; status:string };
const norm = (s:string) => s.toLowerCase().trim().replace(/[^a-z0-9 ]/g,'');
export function matchScore(ride:Ride, from:string, to:string, date:string) {
  const a=norm(from), b=norm(to), rf=norm(ride.from), rt=norm(ride.to);
  let score=0;
  if(a && (rf===a || rf.includes(a) || a.includes(rf))) score+=40;
  else if(a && (rf.split(' ').some(x=>x.length>3 && a.includes(x)))) score+=18;
  if(b && (rt===b || rt.includes(b) || b.includes(rt))) score+=40;
  else if(b && (rt.split(' ').some(x=>x.length>3 && b.includes(x)))) score+=18;
  if(date && ride.date===date) score+=20;
  return Math.min(100,score);
}
export function splitFare(total:number, passengers:number) { return Math.ceil(total/Math.max(1,passengers)); }
