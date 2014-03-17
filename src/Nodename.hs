import System.Linux.Namespace (setNodeName, getNodeName)

import System.Environment
import qualified Data.ByteString.Char8 as BS

main = do
    args <- getArgs
    case args of
        ["get"]      -> do name <- getNodeName
                           putStrLn $ BS.unpack name
        ["set",name] -> setNodeName $ BS.pack name
        _            -> error "bad options"
