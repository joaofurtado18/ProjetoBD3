---------------------
-- (RI-1)
---------------------
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


---------------------
-- (RI-4)
---------------------
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


---------------------
-- (RI-5)
---------------------

CREATE OR REPLACE FUNCTION product_replenishment_proc()
    RETURNS TRIGGER AS
    $$
    BEGIN
        IF NEW.EAN NOT IN (SELECT EAN FROM shelf NATURAL JOIN has_category WHERE EAN=NEW.EAN AND serial_number=NEW.serial_number)
            THEN RAISE EXCEPTION 'Product must be replenished on a shelf that displays one of its categories';
        END IF;
        RETURN NEW;
    END;
    $$ language plpgsql;

CREATE TRIGGER product_replenishment
    BEFORE INSERT 
    ON replenishment_event
    FOR EACH ROW
    EXECUTE PROCEDURE product_replenishment_proc();
