export const idlFactory = ({ IDL }) => {
  const CanisterMetrics = IDL.Record({
    'heapSize' : IDL.Nat,
    'cycles' : IDL.Nat,
  });
  const CDN = IDL.Service({
    'getCanisterMetrics' : IDL.Func([], [CanisterMetrics], ['query']),
    'getRBTElementsCount' : IDL.Func([], [IDL.Nat], ['query']),
    'getRBTreeItem' : IDL.Func(
        [IDL.Text],
        [IDL.Opt(IDL.Vec(IDL.Nat8))],
        ['query'],
      ),
    'hasItemWithKey' : IDL.Func([IDL.Text], [IDL.Opt(IDL.Text)], ['query']),
    'uploadChunk' : IDL.Func([IDL.Text, IDL.Vec(IDL.Nat8)], [IDL.Nat], []),
  });
  return CDN;
};
export const init = ({ IDL }) => { return []; };
