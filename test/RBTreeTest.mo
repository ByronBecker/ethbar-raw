import RBT "../src/RBTreeNulls";
import RBTExp "../src/RBTreeNullsExperiment";

import Debug "mo:base/Debug";
import Nat "mo:base/Nat";


var t = RBT.empty();
var te = RBTExp.empty<Nat>();

Debug.print("t: " # debug_show(t));
Debug.print("te: " # debug_show(te));

RBT.insert(t, "d", 5);
RBTExp.insert<Nat>(te, "d", 5);

Debug.print("t: " # debug_show(t));
Debug.print("te: " # debug_show(te));

RBT.insert(t, "b", 6);
RBTExp.insert<Nat>(te, "b", 6);

Debug.print("t: " # RBT.debugShow(t.tree));
Debug.print("te: " # RBTExp.debugShow<Nat>(te.tree, Nat.toText));

RBT.insert(t, "a", 10);
RBTExp.insert<Nat>(te, "a", 10);
Debug.print("t: " # RBT.debugShow(t.tree));
Debug.print("te: " # RBTExp.debugShow<Nat>(te.tree, Nat.toText));

RBT.insert(t, "c", 7);
RBTExp.insert<Nat>(te, "c", 7);
Debug.print("t: " # RBT.debugShow(t.tree));
Debug.print("te: " # RBTExp.debugShow<Nat>(te.tree, Nat.toText));

RBT.insert(t, "c", 9);
RBTExp.insert<Nat>(te, "c", 9);
Debug.print("t: " # RBT.debugShow(t.tree));
Debug.print("te: " # RBTExp.debugShow<Nat>(te.tree, Nat.toText));

assert RBT.get(t, "a") == RBTExp.get<Nat>(te, "a");
assert RBT.get(t, "b") == RBTExp.get<Nat>(te, "b");
assert RBT.get(t, "c") == RBTExp.get<Nat>(te, "c");
assert RBT.get(t, "d") == RBTExp.get<Nat>(te, "d");
assert RBT.get(t, "f") == RBTExp.get<Nat>(te, "f");

/*
Debug.print("a: " # debug_show(RBT.get(t, "a")));
Debug.print("b: " # debug_show(RBT.get(t, "b")));
Debug.print("c: " # debug_show(RBT.get(t, "c")));
Debug.print("d: " # debug_show(RBT.get(t, "d")));
Debug.print("f: " # debug_show(RBT.get(t, "f")));
*/