classdef test_app < matlab.unittest.TestCase
    % ==========================================================================
    %  This is the test file for the MatlabApplication class.
    %  This test class should be run from the top-level folder.
    % ==========================================================================
    methods(TestClassSetup)
        % Shared setup for the entire test class
    end

    methods(TestMethodSetup)
        % Setup for each test
    end

    methods(Test)
        % Test methods

        function LoadConfig(testCase)
            % ==================================================================
            %  This function tests loading the data.
            % ==================================================================
            [test_imports, test_functions] = core.ConfigLoader.load("+test/test_config.json");

            % This is a hard coded true config
            imports.testclass = '+test/@testclass';
            functions.funct1 = cell(2, 1);
            functions.funct1{1} = 'subfunct1';
            functions.funct1{2}.subfunct2 = cell(2, 1);
            functions.funct1{2}.subfunct2{1} = 'subfunct2a';
            functions.funct1{2}.subfunct2{2} = 'subfunct2b';

            % Verify the two outputs
            testCase.verifyTrue(isequal(test_imports, imports));
            testCase.verifyTrue(isequal(test_functions, functions));
        end

        function ImportPaths(testCase)
            % ==================================================================
            %  This function tests the importing of files
            % ==================================================================
            [imports, ~] = core.ConfigLoader.load("+test/test_config.json");
            importer = core.Importer(imports);
            
            % Test Importer Constructor / Test Symlink Dirs Exist
            path_to_symlink = fullfile(importer.IMPORT_SYM_DIR, "testclass");
            testCase.verifyTrue(exist(path_to_symlink, "dir") == 7);

            % Copy the env_paths for a later check
            env_paths = split(path, ";");

            % Testing Imports
            % importer.import("testclass");

            % Work around for ideal case
            % https://www.mathworks.com/matlabcentral/answers/1877397-dynamic-import-with-evalin-not-possible
            import(importer.import("testclass"));

            % Test Pathguard creation
            testCase.verifyTrue(exist("testclass_path_guard", "var") == 1);

            % Test Pathguard Constructor
            new_env_paths = split(path, ";");
            testCase.verifyTrue(length(setdiff(new_env_paths, env_paths)) == 1);

            % Test Importer import is performed
            testCase.verifyTrue(any(contains(import, "testclass")));

            % Test Pathguard Destructor
            testclass_path_guard.delete()
            env_paths = split(path, ";");
            testCase.verifyTrue(length(setdiff(new_env_paths, env_paths)) == 1);

            % Test Importer Destructor
            importer.delete();
            testCase.verifyTrue(exist(path_to_symlink, "dir") == 0);

        end
    end

end