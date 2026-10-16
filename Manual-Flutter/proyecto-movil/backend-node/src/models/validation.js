export class ApiError extends Error {
  constructor(status, message) {
    super(message);
    this.status = status;
  }
}

function object(value, allowed) {
  if (!value || typeof value !== 'object' || Array.isArray(value) ||
      Object.keys(value).some(key => !allowed.includes(key))) {
    throw new ApiError(400, 'Entrada inválida');
  }
}

function text(value, max) {
  if (typeof value !== 'string' || !value.trim() || value.trim().length > max) {
    throw new ApiError(400, 'Texto vacío o demasiado largo');
  }
  return value.trim();
}

export function taskInput(value) {
  object(value, ['title', 'completed', 'category_id']);
  const title = text(value.title, 200);
  const completed = value.completed === undefined ? false : value.completed;
  const category_id = value.category_id ?? null;
  if (typeof completed !== 'boolean' ||
      (category_id !== null && (!Number.isSafeInteger(category_id) || category_id <= 0))) {
    throw new ApiError(400, 'Tipos inválidos');
  }
  return {title, completed, category_id};
}

export function userInput(value) {
  object(value, ['nombre', 'correo']);
  const nombre = text(value.nombre, 100);
  const correo = text(value.correo, 150).toLowerCase();
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(correo)) throw new ApiError(400, 'Correo inválido');
  return {nombre, correo};
}

export function positiveId(value) {
  if (!/^[1-9]\d*$/.test(value) || !Number.isSafeInteger(Number(value))) {
    throw new ApiError(400, 'Identificador inválido');
  }
  return Number(value);
}
