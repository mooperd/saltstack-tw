mine_functions:
  function_one:
    - mine_function: grains.get
    - localhost
  function_two:
    - mine_function: grains.get
    - osrelease
  function_three:
    - mine_function: grains.get
    - shell
  function_four:
    - mine_function: grains.get
    - ec2[local_ipv4]
