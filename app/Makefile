NAME:=$(shell basename `git rev-parse --show-toplevel`)
HASH:=$(shell git rev-parse --verify --short HEAD)

run-ios: ios-sim
	flutter run

ios-sim:
	open -a Simulator
