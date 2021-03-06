module Data.URI.RelativePart where

import Prelude
import Control.Alt ((<|>))
import Control.Apply ((*>))
import Data.Array (catMaybes)
import Data.Maybe (Maybe(..))
import Data.URI.Authority
import Data.URI.Common
import Data.URI.Path
import Data.URI.Types
import qualified Data.String as S
import Text.Parsing.StringParser (Parser())
import Text.Parsing.StringParser.Combinators (optionMaybe)
import Text.Parsing.StringParser.String (string)

parseRelativePart :: Parser RelativePart
parseRelativePart = (RelativePart <$> optionMaybe (string "//" *> parseAuthority) <*> parsePathAbEmpty parseURIPathRel)
                <|> (RelativePart Nothing <$> ((Just <$> parsePathAbsolute parseURIPathRel)
                                          <|> (Just <$> parsePathNoScheme parseURIPathRel)
                                          <|> pure Nothing))

printRelativePart :: RelativePart -> String
printRelativePart (RelativePart a p) =
  S.joinWith "" $ catMaybes [ printAuthority <$> a
                            , printPath <$> p
                            ]
