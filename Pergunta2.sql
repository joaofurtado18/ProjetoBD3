CREATE OR REPLACE FUNCTION cat_r1_proc()
    RETURNS TRIGGER AS
    $$
    BEGIN
        IF NEW.category_name = NEW.super_category_name
            THEN RAISE EXCEPTION 'Cannot insert a category into itself';
        END IF;
        RETURN NEW;
    END;
    $$ language plpgsql;

CREATE TRIGGER cat_r1 
    BEFORE INSERT 
    ON has_other
    FOR EACH ROW
    EXECUTE PROCEDURE cat_r1_proc();

CREATE OR REPLACE FUNCTION units_planogram_replenishment_proc()
    RETURNS TRIGGER AS
    $$
    BEGIN
        IF (SELECT units < NEW.units FROM planogram WHERE EAN = NEW.EAN)
            THEN RAISE EXCEPTION 'Number of units must be less or equal than the number definied on the planogram';
        END IF;
        RETURN NEW;
    END;
    $$ language plpgsql;

CREATE TRIGGER units_planogram_replenishment
    BEFORE INSERT 
    ON replenishment_event
    FOR EACH ROW
    EXECUTE PROCEDURE units_planogram_replenishment_proc();
