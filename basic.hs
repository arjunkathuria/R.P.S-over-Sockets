{-# LANGUAGE OverloadedStrings #-}
import System.IO
import Network.Run.TCP
import Network.Socket
import Network.Socket.ByteString (recv, send, sendAll)
import qualified Data.ByteString.Char8 as C

data Move = Rock | Paper | Scissors
  deriving (Eq, Read, Show, Enum, Bounded)

data Outcome = Lose | Tie | Win deriving (Show, Eq, Ord)

outcome :: Move -> Move -> Outcome
outcome Rock Scissors = Win
outcome Paper Rock = Win
outcome Scissors Paper = Win
outcome us them
  | us == them = Tie
  | otherwise = Lose

parseMove :: String -> Maybe Move
parseMove str
  | [(move, "")] <- reads str :: [(Move, String)] = Just move
  | otherwise = Nothing

getMove :: Handle -> IO Move
getMove h = do
  hPutStrLn h $ "Please Enter One of " ++ show ([minBound..] :: [Move])
  input <- hGetLine h
  case parseMove input of
    Just move -> return move
    Nothing -> getMove h

computerVsUser :: Move -> Handle -> IO ()
computerVsUser computerMove h = do
  userMove <- getMove h
  let o = outcome userMove computerMove
  let str = "You " ++ show o
  hPutStrLn h str

type Hostname = String
type PortID = String

withClient :: Hostname -> PortID -> (Handle -> IO ()) -> IO ()
withClient hostname listenPort fn = do
  runTCPServer (Just hostname) listenPort f
    where f sock = do
            handle <- socketToHandle sock ReadWriteMode
            fn handle
            hClose handle
