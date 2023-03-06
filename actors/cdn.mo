import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Prim "mo:prim";
import RBT "../src/RBTreeNullsExperiment";
import Cycles "mo:base/ExperimentalCycles";


shared ({ caller = creator }) actor class CDN() = this {
  stable var stableRBTree = RBT.empty<Blob>();

  stable var count = 0;

  public shared({caller = caller}) func uploadChunk(id: Text, chunk: Blob): async Nat {
    if (caller == creator) {
      RBT.insert<Blob>(stableRBTree, id, chunk);
      count += 1;
      return count;
    };

    0;
  };


  //////////////////////////////////////////////////////////////////////////////////////////////////

  type CanisterMetrics = {
    heapSize: Nat; 
    cycles: Nat;
  };

  public query func getCanisterMetrics() : async CanisterMetrics {
    {
      heapSize = Prim.rts_heap_size();
      cycles = Cycles.balance();
    }
  };

  /*
  public func clear(): () {
    stableRBTree := RBT.empty<Blob>();
    count := 0;
  };
  */

  public query func getRBTreeItem(k: Text): async ?Blob {
    RBT.get<Blob>(stableRBTree, k);
  };

  public query func hasItemWithKey(k: Text): async ?Text {
    if (RBT.has<Blob>(stableRBTree, k)) ?k else null;
  };

  public query func getRBTElementsCount(): async Nat {
    count
  };
};