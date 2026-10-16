import {mongoDb} from '../config/database.js';

export async function recordActivity(actor, action, task_id) {
  const event = {actor, action, task_id, at: new Date()};
  try {
    await mongoDb.collection('activity').insertOne({...event});
    await mongoDb.collection('logs').insertOne({...event, level: 'info', source: 'api'});
    return true;
  } catch {
    console.warn('Activity store unavailable; task mutation committed');
    return false;
  }
}
