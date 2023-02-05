classdef test_app < matlab.unittest.TestCase
    % ==========================================================================
    %  This is the test file for the MatlabApplication class.
    %  This test class should be run from the top-level folder.
    % ==========================================================================
    methods(TestClassSetup)
        function setupOnce(testCase)
            % Shared setup for the entire test class

            dir_obj = dir("+test/testlogic");
            file_names = {dir_obj.name};

            % Ignore directories. There should be no dirs in test or logic
            dir_obj = dir_obj(~[dir_obj.isdir]);

            % Go through the test directory and move things into the logic
            % folder. This maybe automated better with MATLAB's new fixture
            % system.
            for test_file = dir_obj.'

                % Get the path and copy the file over to "+logic"
                file_path = fullfile(test_file.folder, test_file.name);
                copyfile(file_path, fullfile("+logic", test_file.name));

            end % for

        end % function

    end % method

    methods(TestClassTeardown)
        function tearDownOnce(testCase)
            % Shared teardown for the entire test class

            % Get the files in the two logic folders
            test_dir_obj = dir("+test/testlogic");
            logic_dir_obj = dir("+logic");
            
            % Get the names of the file from the test logic folder
            file_names = {test_dir_obj.name};
            file_names = file_names(~[test_dir_obj.isdir]);

            % Ignore directories. There should be no dirs in test or logic.
            logic_dir_obj = logic_dir_obj(~[logic_dir_obj.isdir]);

            % Loop through the files names
            for test_file = logic_dir_obj.'

                % If the names files from within the test logic folder
                % matches the names of the items with in the logic folder.
                % Remove those files. This can be further refines to maybe
                % rename all folders for test or generate new folders for
                % test and it should be done in the off chance filenames
                % conflict with the test file names.
                if any(contains(file_names, test_file.name))
                    delete(fullfile("+logic", test_file.name));
                end % if

            end % for

        end % function

    end % method

    methods(Test)
        % Test methods

        function LoadConfig(testCase)
            % ==================================================================
            %  This function tests loading the data.
            % ==================================================================
            [test_imports, test_functions] = core.ConfigLoader.load("+test/test_config.json");

            % This is a hard coded true config
            imports.testclass = '+test\testclass';
            functions.testEngineOne = {'testOpaqueOne'};
            functions.testEngineTwo = {'testOpaqueTwo'};

            % Verify the two outputs
            testCase.assertEqual(test_imports, imports);
            testCase.assertEqual(test_functions, functions);

        end % function

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

        end % function

        function CreateOpaqueBox(testCase)
            % ==================================================================
            %  This function tests the running of OpaqueBoxes
            % ==================================================================

            import logic.*

            % Construct the boxes
            test_box_one = testOpaqueOne();
            test_box_two = testOpaqueTwo();

            % Create the struct that acts as the workspace
            test_work_struct = struct();

            % Run the boxes in line
            test_work_struct = test_box_one.run(test_work_struct);
            test_work_struct = test_box_two.run(test_work_struct);

            work_struct.testfieldA = 1;
            work_struct.testfieldB = "test";
            work_struct.testfieldC = 2;

            % Validate the structures are the same.
            testCase.assertEqual(test_work_struct, work_struct);

            %% These tests throw an error
            try
                % Test what happens if the wrong type is given
                work_struct.testfieldA = "a";
                test_box_two(work_struct);
                testCase.assertFail();

            catch
                % This means it worked!
                % Do nothing

            end % try catch

            try
                % Test what happens if a field does not exist
                work_struct = rmfield(work_struct, "testfieldA");
                test_box_two(work_struct);
                testCase.assertFail();
            catch
                % This means it worked!
                % Do nothing

            end % try catch

        end % function

        function RunUtilBox(testCase)
            % ==================================================================
            %  This function tests the UtilEngine Runs properly
            % ==================================================================
            import logic.*

            % Create Data Obj
            work_struct = struct();

            % Construct the boxes
            test_box_one = testOpaqueOne();
            test_box_two = testOpaqueTwo();

            % Make the truth
            true_work_struct.testfieldA = 1;
            true_work_struct.testfieldB = "test";
            true_work_struct.testfieldC = 2;

            % Set the data
            engine = common.UtilBox(action_items={test_box_one, test_box_two});

            % Run the data
            work_struct = engine.run(work_struct);

            % Verify both are the same
            testCase.assertEqual(true_work_struct, work_struct);

        end % function

        function LoadFunctions(testCase)
            % ==================================================================
            %  The function loads in the values from the configuration to
            %  ensure that we have configuration processing chains.
            % ==================================================================
            [~, functions] = core.ConfigLoader.load("+test/test_config.json");
            utilbox_list = core.FunctionLoader.load(functions);

            % Create Data Obj
            work_struct = struct();

            % Run the First Box
            work_struct = utilbox_list{1}.run(work_struct);

            % Create True Test
            true_work_struct.testfieldA = 1;
            true_work_struct.testfieldB = "test";

            % Check Valid Struct
            testCase.assertEqual(true_work_struct, work_struct);

            % Run the Second Box
            work_struct = utilbox_list{2}.run(work_struct);

            % Check Valid Struct
            true_work_struct.testfieldC = 2;
            testCase.assertEqual(true_work_struct, work_struct);

        end % function

    end % method

end % classdef