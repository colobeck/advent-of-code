from collections import defaultdict

disk_size = 70000000        # Part 2
needed_size = 30000000      # Part 2

with open('d8short.txt', 'r') as fh:
    lines = [line.strip() for line in fh.readlines()]
ggg = len(lines[0])
hhh = len(lines)
visible = 2 * len(lines[0]) + 2*(len(lines) - 2)
print(f'Starting visible: {visible}')
ending_row_idx = len(lines) - 2      # 2nd to last row
ending_col_idx = len(data[0]) - 2   # 2nd to last col



