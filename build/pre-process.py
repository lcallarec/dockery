#!/usr/bin/env python

import os
import shutil
import sys


class PreProcessor:
	
	def __init__(self, from_path, to_path):
		self.from_path = from_path
		self.to_path   = to_path
	
	def copy(self):
	
		for root, filename in self.__iterate_files(self.from_path):
			if filename.endswith('.vala'):
				basename = (root + os.path.sep + filename).replace(os.path.sep, '_')
				shutil.copy(os.path.join(root, filename), self.to_path + os.path.sep + basename)

	def pre_process_for(self, flag):
		processed_content = ""
		for root, filename in self.__iterate_files(self.to_path):
			print root + os.path.sep + filename
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

	def clean_pre_process(self, flag):

		processed_content = ""
		for root, filename in self.__iterate_files(self.to_path):
			with open(root + os.path.sep + filename, 'r') as file:
				must_be_removed = False
				for line in file:
					if "#if " + flag in line:
						must_be_removed = True
					elif must_be_removed == True and "#endif" not in line:
						processed_content += line
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
				
	def __iterate_files(self, path):
		for root, directories, filenames in os.walk(path):
			for filename in filenames:
				yield root, filename			


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

            return versions[version_is_at + 1:]

        except ValueError:
            return None


if __name__ == '__main__':
	pre_processor = PreProcessor(sys.argv[1], sys.argv[2])
	pre_processor.copy()

    #GTK pre-processor
	gtk_versions = GtkVersions()
	for version in gtk_versions.get_versions_prior(sys.argv[3]):
		pre_processor.pre_process_for("GTK_LTE_" + version.replace(".", "_"))

	for version in gtk_versions.get_versions_after(sys.argv[3]):
		pre_processor.pre_process_for("GTK_GTE_" + version.replace(".", "_"))
        pre_processor.clean_pre_process("GTK_")
