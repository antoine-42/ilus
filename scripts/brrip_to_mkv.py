#!/usr/bin/env python3
"""Convert all BDMV downloads by radarr to mkv files, with no quality loss.
The mkvs are then automatically imported by Radarr.

Requires MKVmerge (mkvtoolnix) to be installed.
"""

import os
import time
import subprocess

ROOT = "/mnt/storage"
RADARR_DL_DIR = os.path.join(ROOT, "temp/radarr")
STREAM_PATH = "BDMV/STREAM"


def test():
    """Test whether the program can run or not.

    :return: bool
    """
    can_run = True

    mkvmerge_out = subprocess.run(["mkvmerge", "--version"], stdout=subprocess.PIPE)
    if not mkvmerge_out.stdout.decode("utf-8").startswith("mkvmerge v"):
        print("It looks like mkvmerge isn't available. Please install mkvtoolnix")
        can_run = False

    if not os.path.isdir(RADARR_DL_DIR):
        print("The radarr download directory isn't available. Please update it.")
        can_run = False

    return can_run


def get_dir_size(start_path):
    """Get the sum of all files in a directory. Recursive.

    :param start_path: str
    :return: int
    """
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(start_path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            # skip if it is symbolic link
            if not os.path.islink(fp):
                total_size += os.path.getsize(fp)
    return total_size


def get_biggest_file_in_dir(path):
    """Get the biggest file at a path, return its name and size.

    :param path: str
    :return: str, int
    """
    files = os.listdir(path)
    biggest_file = None
    highest_size = 0
    for file in files:
        size = os.path.getsize(os.path.join(path, file))
        if size > highest_size:
            highest_size = size
            biggest_file = file
    return biggest_file, highest_size


def convert_bdmv(movie_path, stream_path):
    output = os.path.join(movie_path, movie_dir) + ".mkv"
    dir_size = get_dir_size(movie_path)
    # Remove files from previous imports, if any.
    if os.path.isfile(output):
        os.remove(output)
    # Check if the download is finished
    if any([file for file in os.listdir(stream_path) if file.endswith(".part")]):
        print("{}: download not finished.".format(
            movie_path))
        return False, "unfinished"
    # Get biggest file
    movie_file, file_size = get_biggest_file_in_dir(stream_path)
    movie_file_path = os.path.join(stream_path, movie_file)
    movie_file_ratio = file_size / dir_size
    # Check if the biggest file / total directory size ratio is too small.
    # It would mean that the m2ts files are split into many parts.
    if movie_file_ratio > 0.7:
        print("Converting {} to mkv, file size is {}GB, {}% of movie folder size.".format(
            movie_file_path, round(file_size / 1000000000, 1),  round(movie_file_ratio * 100, 1)))
        # Call to mkvmerge
        mkvmerge_command = 'mkvmerge -q -o {output}.part --compression -1:none {input}'.format(
            output=output, input=movie_file_path)
        subprocess.run(mkvmerge_command.split(" "))
        # Keep radarr from copying the file until conversion is finished.
        os.rename(output + ".part", output)
        return True, movie_file_ratio
    print("{}: biggest file size is {}GB, {}% of movie folder size. Movie is fucked up, conversion impossible.".format(
        movie_file_path, round(file_size / 1000000000, 1),  round(movie_file_ratio * 100, 1)))
    return False, movie_file_ratio


if __name__ == "__main__":
    if test():
        movie_dirs = os.listdir(RADARR_DL_DIR)
        converted = 0
        not_converted = []
        start_time = time.time()
        for movie_dir in movie_dirs:
            movie_path = os.path.join(RADARR_DL_DIR, movie_dir)
            stream_path = os.path.join(movie_path, STREAM_PATH)
            if os.path.isdir(stream_path):
                # Don't import a file that has already been imported
                curr_imported_mark = os.path.join(movie_path, ".imported")
                if not os.path.isfile(curr_imported_mark):
                    status = convert_bdmv(movie_path, stream_path)
                    if status[0]:
                        file = open(curr_imported_mark, 'w')
                        file.close()
                        converted += 1
                    else:
                        not_converted.append((movie_dir, status[1]))
        end_time = time.time()
        print("\ncouldn't import:")
        for tup in not_converted:
            print("    {1}: {0}".format(*tup))
        print("{} files converted in {} minutes. Exiting...".format(converted, (end_time - start_time) / 60))
