module LLVM.Codegen.Type
  ( Type(..)
  , i1
  , i8
  , i16
  , i32
  , i64
  , ptr
  , void
  ) where

import LLVM.Codegen.Name
import LLVM.Pretty
import Data.Word

-- TODO: flag
type Packed = Bool

data Type
  = IntType Word32
  | FunctionType Type [Type]
  | PointerType Type
  | VoidType
  | StructureType Packed [Type]
  | ArrayType Word32 Type
  | NamedTypeReference Name
  deriving Show

i1, i8, i16, i32, i64 :: Type
i1 = IntType 1
i8 = IntType 8
i16 = IntType 16
i32 = IntType 32
i64 = IntType 64

ptr :: Type -> Type
ptr = PointerType

void :: Type
void = VoidType

instance Pretty Type where
  pretty = \case
    PointerType ty ->
      pretty ty <> "*"
    IntType bits ->
      "i" <> pretty bits
    FunctionType retTy argTys ->
      pretty retTy <+> tupled (map pretty argTys)
    NamedTypeReference name ->
      "%" <> pretty name
    VoidType ->
      "void"
    StructureType packed elemTys
      | packed ->
        "<{" <> (commas $ map pretty elemTys ) <> "}>"
      | otherwise ->
        "{" <> (commas $ map pretty elemTys ) <> "}"
    ArrayType count ty ->
      brackets $ pretty count <+> "x" <+> pretty ty
