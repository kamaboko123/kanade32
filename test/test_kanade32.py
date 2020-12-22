import pytest
import subprocess
import json
import re

pytest.CONFIG_FILE_NAME="test_dataset.json"
pytest.CONFIG = {}
pytest.TEST_MIPS_PARAM = []

def load_config():
    with open(pytest.CONFIG_FILE_NAME, "r") as f:
        pytest.CONFIG = json.loads(f.read())

def compile_mem_files():
    for cmdset in pytest.CONFIG["cmd"]["before_test"]:
        subprocess.check_output(cmdset)

def collect_registers(output):
    registers_name = ["zero", "at", "v0", "v1", "a0", "a1", "a2", "a3", "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7", "t8", "t9", "k0", "k1", "gp", "sp", "fp", "ra"]
    _ret = {}
    for line in output.splitlines():
        matches = re.findall(r"^(.+): (0x\d+)$", line.decode('utf-8'))
        if(len(matches) != 1 or len(matches[0]) != 2):
            continue
        if(not matches[0][0] in registers_name):
            continue
        _ret[matches[0][0]] = matches[0][1]
    
    return _ret

load_config()
compile_mem_files()

def pytest_generate_tests(metafunc):
    if 'testdata' in metafunc.fixturenames:
        metafunc.parametrize('testdata', pytest.CONFIG["tests"])

def test_mips(testdata):
    mem_file = testdata["mem"]
    expected_regs = testdata["assert"]["registers"]

    cmd = ["bash", "-c", "cd ../; make clean; make"]
    result = subprocess.check_output(cmd, env={"MEM_FILE":mem_file})
    reg_dumps = collect_registers(result)

    for reg_name in expected_regs.keys():
        assert reg_dumps[reg_name] == expected_regs[reg_name]

