function test()
        [imports, functions] = core.ConfigLoader.load("+test/test_config.json");
        importer = core.Importer(imports);
        import(importer.import("testclass"));
        action_list = [testOpaqueOne testOpaqueTwo];
        keyboard
end