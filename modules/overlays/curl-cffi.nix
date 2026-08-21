{
  nixpkgs.overlays = [
    (_: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (_: pythonPrev: {
          curl-cffi = pythonPrev.curl-cffi.overridePythonAttrs (oldAttrs: {
            # TODO: Remove when NixOS/nixpkgs#554482 reaches nixpkgs-unstable.
            disabledTestPaths = (oldAttrs.disabledTestPaths or [ ]) ++ [
              "tests/unittest/test_async_session.py::test_verify"
              "tests/unittest/test_curl.py::test_verify"
              "tests/unittest/test_requests.py::test_verify"
              "tests/unittest/test_requests.py::test_delete_cookies"
            ];
          });
        })
      ];
    })
  ];
}
