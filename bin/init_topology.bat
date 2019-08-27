call %~dp0env.bat
set CLUSTER=%1
set EVAL_FILE=%SRC_DIR%/%CLUSTER%/topology.rb
if exist "%EVAL_FILE%"  (
  start_rvec_node.bat m1 --ntf-stat-period 10 --eval %EVAL_FILE% 
) else (
  echo "topology init file does not exists: %EVAL_FILE%"
)

