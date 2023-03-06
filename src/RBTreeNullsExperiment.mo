import Debug "mo:base/Debug";
import Text "mo:base/Text";

module RBTree {

  type Node<V> = {
    key: Text;
    var fields: {
      red: Bool;
      parent: ?Node<V>;
      value: V;
      left: ?Node<V>;
      right: ?Node<V>;
    };
  };

  public type RBTree<V> = {
    var tree : ?Node<V>;
  };


  public func empty<V>(): RBTree<V> = { 
    var tree = null;
  };

  func initNode<V>(key: Text, value: V): Node<V> {
    {
      key = key;
      var fields = {
        red = true;
        parent = null;
        value = value;
        left = null;
        right = null;
      }
    }
  };


  public func has<V>(root: RBTree<V>, key: Text): Bool {
    Debug.print("called get with key: " # key);
    hasHelper<V>(root.tree, key);
  };

  func hasHelper<V>(node: ?Node<V>, key: Text): Bool {
    var currentNode = node;
    var ret: ?Text = null;
    label l loop {
      switch(currentNode) {
        case null { break l };
        case (?n) {
          if (n.key < key) { currentNode := n.fields.right }
          else if (n.key > key) { currentNode := n.fields.left}
          else { // n.key == key
            return true;
          }
        }
      }
    };

    false
  };

  public func get<V>(root: RBTree<V>, key: Text): ?V {
    Debug.print("called get with key: " # key);
    getHelper<V>(root.tree, key);
  };

  func getHelper<V>(node: ?Node<V>, key: Text): ?V {
    var currentNode = node;
    var ret: ?V = null;
    label l loop {
      switch(currentNode) {
        case null { break l };
        case (?n) {
          if (n.key < key) { currentNode := n.fields.right }
          else if (n.key > key) { currentNode := n.fields.left}
          else { // n.key == key
            ret := ?n.fields.value;
            break l;
          }
        }
      }
    };

    ret
  };

  public func insert<V>(root: RBTree<V>, key: Text, value: V): () {
    var node = initNode<V>(key, value);

    var tree = root.tree;
    var parent: ?Node<V> = null;


    label l loop {
      switch(tree) {
        case null { break l };
        case (?t) {
          parent := tree;
          if (node.key < t.key) {
            tree := t.fields.left;
          } else if (node.key == t.key) {
            t.fields := {
              red = t.fields.red;
              parent = t.fields.parent;
              value = node.fields.value;
              left = t.fields.left;
              right = t.fields.right;
            };
            return;
          } else {
            tree := t.fields.right;
          };
        } 
      }
    };

    node.fields := {
      red = node.fields.red;
      parent = parent;
      value = node.fields.value;
      left = node.fields.left;
      right = node.fields.right;
    };

    switch(parent) {
      case null {
        node.fields := {
          red = false;
          parent = node.fields.parent;
          value = node.fields.value;
          left = node.fields.left;
          right = node.fields.right;
        };
        root.tree := ?node;
        return;
      };
      case (?p) {
        if (node.key < p.key) {
          p.fields := {
            red = p.fields.red;
            parent = p.fields.parent;
            value = p.fields.value;
            left = ?node;
            right = p.fields.right;
          }
        } else {
          p.fields := {
            red = p.fields.red;
            parent = p.fields.parent;
            value = p.fields.value;
            left = p.fields.left;
            right = ?node;
          }
        };

        switch(p.fields.parent) {
          case null { return };
          case (?gp) {
            fitInsert<V>(root, node, p, gp);
          }
        }
      }
    };
  };

  // If necessary, fix node red/black coloring and rotate 
  func fitInsert<V>(root: RBTree<V>, n: Node<V>, parent: Node<V>, gp: Node<V>): () {
    var node = n;
    label l loop {
      if (nodeKeyEquals(?parent, gp.fields.right)) {
        switch(gp.fields.left) {
          case null { 
            if (nodeKeyEquals(?node, parent.fields.left)) {
              node := parent;
              rightRotate<V>(root, node)
            };

            parent.fields := {
              red = false;
              parent = parent.fields.parent;
              value = parent.fields.value;
              left = parent.fields.left;
              right = parent.fields.right;
            };
            gp.fields := {
              red = true;
              parent = gp.fields.parent;
              value = gp.fields.value;
              left = gp.fields.left;
              right = gp.fields.right;
            };
            leftRotate<V>(root, gp)
          };
          case (?uncle) {
            if (uncle.fields.red == true) {
              uncle.fields := {
                red = false;
                parent = uncle.fields.parent;
                value = uncle.fields.value;
                left = uncle.fields.left;
                right = uncle.fields.right;
              };
              parent.fields := {
                red = false;
                parent = parent.fields.parent;
                value = parent.fields.value;
                left = parent.fields.left;
                right = parent.fields.right;
              };
              gp.fields := {
                red = true;
                parent = gp.fields.parent;
                value = gp.fields.value;
                left = gp.fields.left;
                right = gp.fields.right;
              };
              node := gp;
            } else {
              if (nodeKeyEquals(?node, parent.fields.left)) {
                node := parent;
                rightRotate<V>(root, node)
              };

              parent.fields := {
                red = false;
                parent = parent.fields.parent;
                value = parent.fields.value;
                left = parent.fields.left;
                right = parent.fields.right;
              };
              gp.fields := {
                red = true;
                parent = gp.fields.parent;
                value = gp.fields.value;
                left = gp.fields.left;
                right = gp.fields.right;
              };
              leftRotate<V>(root, gp)
            } 
          }
        }
      } else {
        switch(gp.fields.right) {
          case null { 
            if (nodeKeyEquals(?node, parent.fields.right)) {
              node := parent;
              leftRotate<V>(root, node)
            };

            parent.fields := {
              red = false;
              parent = parent.fields.parent;
              value = parent.fields.value;
              left = parent.fields.left;
              right = parent.fields.right;
            };
            gp.fields := {
              red = true;
              parent = gp.fields.parent;
              value = gp.fields.value;
              left = gp.fields.left;
              right = gp.fields.right;
            };
            rightRotate<V>(root, gp)
          };
          case (?uncle) {
            if (uncle.fields.red == true) {
              uncle.fields := {
                red = false;
                parent = uncle.fields.parent;
                value = uncle.fields.value;
                left = uncle.fields.left;
                right = uncle.fields.right;
              };
              parent.fields := {
                red = false;
                parent = parent.fields.parent;
                value = parent.fields.value;
                left = parent.fields.left;
                right = parent.fields.right;
              };
              gp.fields := {
                red = true;
                parent = gp.fields.parent;
                value = gp.fields.value;
                left = gp.fields.left;
                right = gp.fields.right;
              };
            } else {
              if (nodeKeyEquals(?node, parent.fields.right)) {
                node := parent;
                leftRotate<V>(root, node)
              };

              parent.fields := {
                red = false;
                parent = parent.fields.parent;
                value = parent.fields.value;
                left = parent.fields.left;
                right = parent.fields.right;
              };
              gp.fields := {
                red = true;
                parent = gp.fields.parent;
                value = gp.fields.value;
                left = gp.fields.left;
                right = gp.fields.right;
              };
              rightRotate<V>(root, gp)
            }
          }
        }
      };

      if (nodeKeyEquals(?node, root.tree)) {
        break l;
      };

    } while (parent.fields.red == true);

    switch(root.tree) {
      case null { assert false };
      case (?t) { 
        t.fields := {
          red = false;
          parent = t.fields.parent;
          value = t.fields.value;
          left = t.fields.left;
          right = t.fields.right;
        };
      }
    }
  };

  func leftRotate<V>(root: RBTree<V>, node: Node<V>): () {
    switch(node.fields.right) {
      case null { /*TODO assert false? */ };
      case (?parent) {
        node.fields := {
          red = node.fields.red;
          parent = node.fields.parent;
          value = node.fields.value;
          left = node.fields.left;
          right = parent.fields.left;
        };
        switch(parent.fields.left) {
          case null {};
          case (?lp) {
            lp.fields := {
              red = lp.fields.red;
              parent = ?node;
              value = lp.fields.value;
              left = lp.fields.left;
              right = lp.fields.left;
            };
          };
        };

        parent.fields := {
          red = parent.fields.red;
          parent = node.fields.parent;
          value = parent.fields.value;
          left = parent.fields.left;
          right = parent.fields.right;
        };
        
        switch(node.fields.parent) {
          case null { root.tree := ?parent };
          case (?p) {
            if (nodeKeyEquals(?node, p.fields.left)) {
              p.fields := {
                red = p.fields.red;
                parent = p.fields.parent;
                value = p.fields.value;
                left = ?parent;
                right = p.fields.right;
              };
            } else {
              p.fields := {
                red = p.fields.red;
                parent = p.fields.parent;
                value = p.fields.value;
                left = p.fields.left;
                right = ?parent;
              };
            }
          }
        };

        parent.fields := {
          red = parent.fields.red;
          parent = parent.fields.parent;
          value = parent.fields.value;
          left = ?node;
          right = parent.fields.right;
        };
        node.fields := {
          red = node.fields.red;
          parent = ?parent;
          value = node.fields.value;
          left = node.fields.left;
          right = node.fields.right;
        };
      }
    }
  };


  func rightRotate<V>(root: RBTree<V>, node: Node<V>): () {
    switch(node.fields.left) {
      case null { /*TODO assert false? */ };
      case (?parent) {
        node.fields := {
          red = node.fields.red;
          parent = node.fields.parent;
          value = node.fields.value;
          left = node.fields.right;
          right = parent.fields.right;
        };
        switch(parent.fields.right) {
          case null {};
          case (?rp) {
            rp.fields := {
              red = rp.fields.red;
              parent = ?node;
              value = rp.fields.value;
              left = rp.fields.left;
              right = rp.fields.right;
            };
          };
        };

        parent.fields := {
          red = parent.fields.red;
          parent = node.fields.parent;
          value = parent.fields.value;
          left = parent.fields.left;
          right = parent.fields.right;
        };
        
        switch(node.fields.parent) {
          case null { root.tree := ?parent };
          case (?p) {
            if (nodeKeyEquals(?node, p.fields.right)) {
              p.fields := {
                red = p.fields.red;
                parent = p.fields.parent;
                value = p.fields.value;
                left = p.fields.left;
                right = ?parent;
              };
            } else {
              p.fields := {
                red = p.fields.red;
                parent = p.fields.parent;
                value = p.fields.value;
                left = ?parent;
                right = p.fields.right;
              };
            }
          }
        };

        parent.fields := {
          red = parent.fields.red;
          parent = parent.fields.parent;
          value = parent.fields.value;
          left = parent.fields.left;
          right = ?node;
        };
        node.fields := {
          red = node.fields.red;
          parent = ?parent;
          value = node.fields.value;
          left = node.fields.left;
          right = node.fields.right;
        };
      }
    }
  };

  func nodeKeyEquals<V>(n1: ?Node<V>, n2: ?Node<V>): Bool {
    switch(n1, n2) {
      case (null, null) { true };
      case (?n1, ?n2) { n1.key == n2.key };
      case _ { false }
    }
  };

  public func debugShow<V>(node: ?Node<V>, valueDebug: (V) -> Text): Text {
    switch(node) {
      case null { "null" };
      case (?n) {
        "node: {key=" # n.key 
        # "; value=" # valueDebug(n.fields.value) 
        # "; red=" # debug_show(n.fields.red) 
        # "; left=" # debugShow<V>(n.fields.left, valueDebug) 
        # "; parent=ignore; right=" # debugShow<V>(n.fields.right, valueDebug) 
        # "}";
      }
    }
  }
}
  