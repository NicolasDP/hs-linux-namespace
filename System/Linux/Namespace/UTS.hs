-- |
-- Module      : System.Linux.Namspace.UTS
-- License     : BSD-style
-- Maintainer  : Nicolas DI PRIMA <nicolas@di-prima.fr>
-- Stability   : experimental
-- Portability : unix
--

module System.Linux.Namespace.UTS
    ( getNodeName
    , setNodeName
    ) where

import qualified Data.ByteString.Char8 as BS (ByteString, packCString, useAsCStringLen)

import Foreign          (allocaBytes)
import Foreign.C.String (CString)
import Foreign.C.Types
import Foreign.C.Error  (getErrno, errnoToIOError)

import Bindings.Posix.Unistd

getNodeName :: IO BS.ByteString
getNodeName = do
    allocaBytes 255 $ \ptr -> do
        ret <- c'gethostname ptr 255
        case ret of
            -1 -> do err <- getErrno
                     ioError $ errnoToIOError "getNodeName" err Nothing Nothing
            _  -> BS.packCString ptr

--foreign import ccall "sethostname" c'sethostname
--    :: CString -> CSize -> IO CInt

setNodeName :: BS.ByteString -> IO ()
setNodeName name = do
    BS.useAsCStringLen name $ \cs -> do
        ret <- c'sethostname (fst cs) (fromIntegral $ snd cs)
        case ret of
            -1 -> do err <- getErrno
                     ioError $ errnoToIOError "setNodeName" err Nothing Nothing
            _  -> return ()
