from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from db import database
from users.router import router as userrouter
from starlette.requests import Request

app = FastAPI()

origins = [
    # "http://192.168.1.*:3000"
    "http://localhost:3000"
]

app.add_middleware(
    CORSMiddleware,
    # allow_origins=origins,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 起動時にDatabaseに接続する。
@app.on_event("startup")
async def startup():
    await database.connect()

# 終了時にDatabaseを切断する。
@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()

# users routerを登録する。
app.include_router(userrouter)

# middleware state.connectionにdatabaseオブジェクトをセットする。
@app.middleware("http")
async def db_session_middleware(request: Request, call_next):
    request.state.connection = database
    response = await call_next(request)
    return response

