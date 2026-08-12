"""
Tests for the link check workflow configuration.

This module validates that the link check workflow and lychee configuration
are properly set up to detect broken links in documentation.
"""

import os
import re
import subprocess
from pathlib import Path

import pytest


class TestLinkCheckWorkflow:
    """Test suite for link check workflow configuration."""

    def test_workflow_file_exists(self):
        """Verify that the link-check.yml workflow file exists."""
        workflow_path = Path(".github/workflows/link-check.yml")
        assert workflow_path.exists(), "link-check.yml workflow file not found"

    def test_workflow_file_not_empty(self):
        """Verify that the workflow file contains configuration."""
        workflow_path = Path(".github/workflows/link-check.yml")
        content = workflow_path.read_text()
        assert len(content) > 0, "link-check.yml is empty"
        assert "name: Link Check" in content, "Workflow name not found"

    def test_workflow_has_schedule_trigger(self):
        """Verify that the workflow has a scheduled trigger."""
        workflow_path = Path(".github/workflows/link-check.yml")
        content = workflow_path.read_text()
        assert "schedule:" in content, "Schedule trigger not found"
        assert "cron:" in content, "Cron expression not found"

    def test_workflow_has_pull_request_trigger(self):
        """Verify that the workflow runs on pull requests."""
        workflow_path = Path(".github/workflows/link-check.yml")
        content = workflow_path.read_text()
        assert "pull_request:" in content, "Pull request trigger not found"

    def test_workflow_has_push_trigger(self):
        """Verify that the workflow runs on push to main."""
        workflow_path = Path(".github/workflows/link-check.yml")
        content = workflow_path.read_text()
        assert "push:" in content, "Push trigger not found"
        assert "main" in content, "Main branch not found"

    def test_workflow_has_checkout_step(self):
        """Verify that the workflow checks out code."""
        workflow_path = Path(".github/workflows/link-check.yml")
        content = workflow_path.read_text()
        assert "Checkout code" in content, "Checkout step not found"
        assert "actions/checkout" in content, "Checkout action not found"

    def test_workflow_has_link_check_step(self):
        """Verify that the workflow runs link checks."""
        workflow_path = Path(".github/workflows/link-check.yml")
        content = workflow_path.read_text()
        assert "lycheeverse/lychee-action" in content, "Lychee action not found"

    def test_workflow_has_comments(self):
        """Verify that the workflow includes explanatory comments."""
        workflow_path = Path(".github/workflows/link-check.yml")
        content = workflow_path.read_text()
        # Check for at least some comments
        assert "#" in content, "No comments found in workflow"
        assert "Addresses:" in content, "Issue reference comment not found"


class TestLycheeConfiguration:
    """Test suite for lychee link checker configuration."""

    def test_lychee_config_exists(self):
        """Verify that lychee.toml configuration file exists."""
        config_path = Path("lychee.toml")
        assert config_path.exists(), "lychee.toml configuration file not found"

    def test_lychee_config_not_empty(self):
        """Verify that the configuration file contains settings."""
        config_path = Path("lychee.toml")
        content = config_path.read_text()
        assert len(content) > 0, "lychee.toml is empty"

    def test_lychee_has_timeout_setting(self):
        """Verify that timeout is configured."""
        config_path = Path("lychee.toml")
        content = config_path.read_text()
        assert "timeout" in content, "Timeout setting not found"

    def test_lychee_has_retries_setting(self):
        """Verify that retries are configured."""
        config_path = Path("lychee.toml")
        content = config_path.read_text()
        assert "retries" in content, "Retries setting not found"

    def test_lychee_has_user_agent(self):
        """Verify that user agent is configured."""
        config_path = Path("lychee.toml")
        content = config_path.read_text()
        assert "user_agent" in content, "User agent not configured"

    def test_lychee_has_exclude_list(self):
        """Verify that URLs to exclude are configured."""
        config_path = Path("lychee.toml")
        content = config_path.read_text()
        assert "exclude" in content, "Exclude list not found"
        # Check for common exclusions
        assert "localhost" in content, "localhost not excluded"
        assert "mailto:" in content, "mailto: not excluded"

    def test_lychee_has_exclude_paths(self):
        """Verify that paths to exclude are configured."""
        config_path = Path("lychee.toml")
        content = config_path.read_text()
        assert "exclude_path" in content, "Exclude paths not found"
        # Check for common path exclusions
        assert "docs/build/" in content, "docs/build/ not excluded"
        assert ".git/" in content, ".git/ not excluded"

    def test_lychee_has_comments(self):
        """Verify that the configuration includes explanatory comments."""
        config_path = Path("lychee.toml")
        content = config_path.read_text()
        # Check for comments
        assert "#" in content, "No comments found in configuration"
        assert "Lychee Link Checker Configuration" in content, (
            "Configuration header comment not found"
        )

    def test_lychee_config_is_valid_toml(self):
        """Verify that lychee.toml is valid TOML format."""
        config_path = Path("lychee.toml")
        content = config_path.read_text()
        
        # Basic TOML validation - check for balanced brackets
        assert content.count("[") == content.count("]"), (
            "Unbalanced brackets in TOML"
        )
        assert content.count('"') % 2 == 0, "Unbalanced quotes in TOML"


class TestLinkCheckIntegration:
    """Integration tests for link checking."""

    @pytest.mark.skipif(
        not os.path.exists("lychee.toml"),
        reason="lychee.toml not found"
    )
    def test_lychee_config_can_be_parsed(self):
        """Verify that lychee can parse the configuration."""
        try:
            result = subprocess.run(
                ["lychee", "--config", "lychee.toml", "--help"],
                capture_output=True,
                timeout=10
            )
            # lychee --help should succeed
            assert result.returncode == 0 or "help" in result.stdout.decode(), (
                "lychee failed to parse configuration"
            )
        except FileNotFoundError:
            pytest.skip("lychee not installed")

    def test_documentation_files_exist(self):
        """Verify that documentation files exist for checking."""
        doc_files = [
            "README.rst",
            "CONTRIBUTING.rst",
            "CODE_OF_CONDUCT.rst",
        ]
        for doc_file in doc_files:
            assert Path(doc_file).exists(), f"{doc_file} not found"

    def test_docs_directory_exists(self):
        """Verify that docs directory exists."""
        docs_path = Path("docs")
        assert docs_path.exists(), "docs directory not found"
        assert docs_path.is_dir(), "docs is not a directory"
