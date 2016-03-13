#!/usr/bin/env python

import os
import shutil
import sys


def copy_source_files(from_path, to_path):

    for root, directories, filenames in os.walk(from_path):
        for filename in filenames:
            if filename.endswith('.vala'):
                basename = (root + os.path.sep + filename).replace(os.path.sep, '_')
                shutil.copy(os.path.join(root, filename), to_path + os.path.sep + basename)

def pre_process_for(source_path, flag):

    processed_content = ""
    for root, directories, filenames in os.walk(source_path):
        for filename in filenames:
            with open(root + os.path.sep + filename, 'r') as file:
                must_be_removed = False
                for line in file:
                    if "#if " + flag in line:
                        must_be_removed = True
                    elif must_be_removed == True and "#endif" not in line:
                        continue
                    elif must_be_removed == True and "#endif" in line:
                        must_be_removed = False
                        continue
                    else:
                        processed_content += line

                file.close()

            with open(root + os.path.sep + filename, 'w') as file:
                file.write(processed_content)
                file.close()

            processed_content = ""

class GtkVersions:

    _min_gtk_version = "3.00"
    _max_gtk_version = "3.18"

    def yield_versions(self):

        version = float(self._min_gtk_version)
        while version <= float(self._max_gtk_version):
            yield "{:.2f}".format(version)
            version = float(version) + 0.02

    def get_versions(self):

        versions = []
        for version in self.yield_versions():
                versions.append(version)

        return versions

    def get_versions_prior(self, version):
        try:
            versions = self.get_versions()
            version_is_at = versions.index(str(version))

            return versions[0:version_is_at + 1]

        except ValueError:
            return None

    def get_versions_after(self, version):
        try:
            versions = self.get_versions()
            version_is_at = versions.index(str(version))

            return versions[version_is_at:]

        except ValueError:
            return None


if __name__ == '__main__':
    copy_source_files(sys.argv[1], sys.argv[2])

    #GTK pre-processor
    gtk_versions = GtkVersions()
    for version in gtk_versions.get_versions_prior(sys.argv[3]):
        pre_process_for(sys.argv[2], "GTK_LTE_" + version.replace(".", "_"))

    for version in gtk_versions.get_versions_after(sys.argv[3]):
        pre_process_for(sys.argv[2], "GTK_GTE_" + version.replace(".", "_"))