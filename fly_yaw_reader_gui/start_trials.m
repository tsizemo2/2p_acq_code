function [ output_args ] = start_trials( run_obj )

stim_type = run_obj.stim_type;

if(strcmp(stim_type, 'Task File') == 1)
    
    task_file_path = run_obj.taskfile_path;
    
    disp(['About to start trials using task file: ' task_file_path]);
    tasks = read_task_file(task_file_path);
    task_cnt = length(tasks);
    
    scanimage_client_skt = '';
    if(run_obj.using_2p == 1)
        scanimage_client_skt = connect_to_scanimage();
        disp(['Connected to scanimage server on socket']);
    end
        
    viz_figs.run_traj_fig = figure();
    viz_figs.velocity_tc_fig = figure();
    viz_figs.velocity_tc_single_fig = figure(); % single trial time course
    session_id = run_obj.session_id;
    
    for i = 1:task_cnt
        cur_task = tasks{i};        
        
        cur_trial_corename = [cur_task '_' datestr(now, 'yyyymmdd_HHMMSS') '_sid_' num2str(session_id) '_tid_' num2str(i-1)];
        %[trial_bdata, trial_time] = run_trial(i, cur_task, run_obj, scanimage_client_skt, cur_trial_corename );
        
        if(run_obj.is_oga == 1) % odor-gated anemotaxis (TO)
            [trial_bdata, trial_time] = run_trial_OGA_flyback(i, cur_task, run_obj, scanimage_client_skt, cur_trial_corename );
            display_trial_with_calibration_TO( cur_task, trial_time, trial_bdata, viz_figs, run_obj.experiment_dir);
        elseif(run_obj.is_windjump == 1) % wind jump in EB (TO)
            [trial_bdata, trial_time] = run_trial_wind_jump_TO(i, cur_task, run_obj, scanimage_client_skt, cur_trial_corename );
            display_trial_with_calibration_TO( cur_task, trial_time, trial_bdata, viz_figs, run_obj.experiment_dir);
        else % osomotropotaxis (SR)
            if(run_obj.using_ephys == 1)
                [trial_bdata, trial_time] = run_trial_OT_ephys(i, cur_task, run_obj, scanimage_client_skt, cur_trial_corename );
            else
                [trial_bdata, trial_time] = run_trial_OT(i, cur_task, run_obj, scanimage_client_skt, cur_trial_corename );                
            end
        end
        
        if( (strcmp(cur_task,'BothOdor') == 1) | (strcmp(cur_task,'RightOdor') == 1) | (strcmp(cur_task,'LeftOdor') == 1) | (strcmp(cur_task,'2pStim') == 1)  | (strcmp(cur_task,'PicoPump') == 1))
            if(run_obj.using_ephys == 1)
                display_trial_ephys( cur_task, trial_time, trial_bdata, viz_figs, run_obj.pre_stim_t, run_obj.stim_t );                   
            else
                display_trial( cur_task, trial_time, trial_bdata, viz_figs );        
            end
        end
        
        % Save data              
        cur_trial_file_name = [ run_obj.experiment_dir '\bdata_' cur_trial_corename '.mat' ];
        save( cur_trial_file_name, 'trial_bdata', 'trial_time' );
        
        % wait for an inter-trial period
        if( i < task_cnt )
            disp(['Finished with trial: ' num2str(i-1) '. Waiting for ' num2str(run_obj.inter_trial_t) ' seconds till next trial']);
            pause(run_obj.inter_trial_t);
        end
    end    
       
    if(run_obj.using_2p == 1)
        fprintf(scanimage_client_skt, 'END_OF_SESSION');
        fclose(scanimage_client_skt);
    end
    
    %if( (strcmp(cur_task,'BothOdor') == 1) | (strcmp(cur_task,'RightOdor') == 1) | (strcmp(cur_task,'LeftOdor') == 1) | (strcmp(cur_task,'2pStim') == 1) )
        % Save viz figures       
        saveas( viz_figs.run_traj_fig, [run_obj.experiment_dir '\run_traj_' datestr(now, 'yyyy_mmdd_HH_MM_SS') '_sid_' num2str(session_id) '.fig'] );
        saveas( viz_figs.velocity_tc_fig, [run_obj.experiment_dir '\velocity_tc_' datestr(now, 'yyyy_mmdd_HH_MM_SS') '_sid_' num2str(session_id) '.fig'] );
    %end
    
    % Update session id    
    set(run_obj.sessiod_id_hdl, 'String', num2str(session_id+1));
    
    disp('Trials complete.')
else
    
    disp(stim_type);
    disp(['ERROR: stim_type: ' stim_type ' is not supported.']);
end

end

