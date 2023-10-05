import subprocess

def run_oc_command(command):
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        if result.returncode == 0:
            return result.stdout
        else:
            return result.stderr
    except Exception as e:
        return str(e)

nodes_output = run_oc_command("oc get nodes")
co_output = run_oc_command("oc get co")
pods_output = run_oc_command("oc get pods -A | egrep -iv 'Running|Completed'")
current_project_pods = run_oc_command(["oc get pods"])

print("Nodes:")
print(nodes_output)

print("\nPods:")
print(pods_output)

print("\nCO:")
print(pods_output)

print("\npods in current project:")
print(current_project_pods)