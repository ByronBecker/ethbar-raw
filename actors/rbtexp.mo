import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Prim "mo:prim";
import RBT "../src/RBTreeNullsExperiment";
import Cycles "mo:base/ExperimentalCycles";


actor Echo {
  stable var stableRBTree = RBT.empty<Blob>();

  stable var count = 0;

  /*
  public func testRBTree(items : Nat) : async Nat {
    // max around 246000

    let tree = RBT.empty();

    for (item in Iter.range(0, items)) RBT.insert(tree, Nat.toText(item), item+1);

    return items;
  };
  */

  public func uploadChunk(id: Text, chunk: Blob): async Nat {
    RBT.insert<Blob>(stableRBTree, id, chunk);

    count += 1;

    return count;
  };


  //////////////////////////////////////////////////////////////////////////////////////////////////

  type CanisterMetrics = {
    heapSize: Nat; 
    cycles: Nat;
  };

  public func getCanisterMetrics() : async CanisterMetrics {
    {
      heapSize = Prim.rts_heap_size();
      cycles = Cycles.balance();
    }
  };

  /*
  public func allocateRBTSpace(start : Nat, count: Nat) : async Nat {
    let end = start + count;

    for (item in Iter.range(start, end)) RBT.insert(stableRBTree, Nat.toText(item), item+1);

    return end;
  };
  */

  public func clear(): () {
    stableRBTree := RBT.empty<Blob>();
    count := 0;
  };

  public func getRBTreeItem(k: Text): async ?Blob {
    RBT.get<Blob>(stableRBTree, k);
  };

  public func hasItemWithKey(k: Text): async ?Text {
    if (RBT.has<Blob>(stableRBTree, k)) ?k else null;
  };

  public func getRBTElementsCount(): async Nat {
    count
  };
};